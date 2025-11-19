{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.profiles.base = {
    enable = lib.mkEnableOption "base system configuration";

    flakeUrl = lib.mkOption {
      type = lib.types.str;
      default = "github:alyraffauf/nixcfg";
      description = "Default flake URL for the system";
    };
  };

  config = lib.mkIf config.myNixOS.profiles.base.enable {
    boot = {
      kernel.sysctl = {
        # Improved file monitoring
        "fs.file-max" = lib.mkDefault 2097152; # Set size of file handles and inode cache
        "fs.inotify.max_user_instances" = lib.mkOverride 100 8192; # Re-use the default from Bazzite even though the default NixOS value is higher.
        "fs.inotify.max_user_watches" = lib.mkOverride 100 524288;

        "kernel.nmi_watchdog" = lib.mkOverride 100 0; # Disable watchdogs for maximum performance at the cost of resiliency
        "kernel.sched_cfs_bandwidth_slice_u" = lib.mkDefault 3000;
        "kernel.sched_latency_ns" = lib.mkDefault 3000000;
        "kernel.sched_migration_cost_ns" = lib.mkDefault 50000;
        "kernel.sched_min_granularity_ns" = lib.mkDefault 300000;
        "kernel.sched_nr_migrate" = lib.mkDefault 128;
        "kernel.sched_wakeup_granularity_ns" = lib.mkDefault 500000;
        "kernel.soft_watchdog" = lib.mkDefault 0;
        "kernel.split_lock_mitigate" = lib.mkDefault 0;
        # "kernel.unprivileged_userns_clone" = lib.mkDefault 1;
        "kernel.watchdog" = lib.mkDefault 0;

        # Network optimizations
        "net.core.default_qdisc" = lib.mkDefault "fq";
        "net.core.netdev_max_backlog" = lib.mkDefault 16384; # Increase netdev receive queue
        "net.ipv4.tcp_congestion_control" = lib.mkDefault "bbr";
        "net.ipv4.tcp_ecn" = lib.mkDefault 1;
        "net.ipv4.tcp_fastopen" = lib.mkDefault 3;
        "net.ipv4.tcp_fin_timeout" = lib.mkDefault 5;
        "net.ipv4.tcp_mtu_probing" = lib.mkForce 1;
        "net.ipv4.tcp_rfc1337" = lib.mkDefault 1; # Protect against tcp time-wait assassination hazards, drop RST packets for sockets in the time-wait state. Not widely supported outside of Linux, but conforms to RFC.
        "net.ipv4.tcp_slow_start_after_idle" = 0; # Disable TCP slow start after idle
        # "net.ipv4.tcp_timestamps" = lib.mkDefault 0; # https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_for_real_time/7/html/tuning_guide/reduce_tcp_performance_spikes

        # Memory management
        "vm.dirty_background_bytes" = lib.mkDefault 134217728;
        "vm.dirty_bytes" = lib.mkDefault 268435456;
        "vm.dirty_writeback_centisecs" = lib.mkDefault 1500;
        "vm.max_map_count" = lib.mkOverride 100 2147483642;
        "vm.page-cluster" = lib.mkDefault 0;
        "vm.swappiness" = lib.mkDefault 150;
        "vm.vfs_cache_pressure" = lib.mkDefault 50;
        "vm.watermark_boost_factor" = lib.mkDefault 0;
        "vm.watermark_scale_factor" = lib.mkDefault 125;
      };

      kernelModules = ["ntsync"];
      kernelPackages = pkgs.linuxPackages_latest;
    };

    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        (inxi.override {withRecommends = true;})
        (lib.hiPrio uutils-coreutils-noprefix)
        git
        helix
        htop
        lm_sensors
        wget
      ];

      variables = {
        FLAKE = config.myNixOS.profiles.base.flakeUrl;
        NH_FLAKE = config.myNixOS.profiles.base.flakeUrl;
      };
    };

    hardware.block = {
      # Default schedulers for rotational and non-rotational devices
      defaultScheduler = "kyber";
      defaultSchedulerRotational = "bfq";

      scheduler = {
        "mmcblk[0-9]*" = "bfq";
        "nvme[0-9]*" = "kyber";
      };
    };

    programs = {
      dconf.enable = true; # Needed for home-manager

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      nh.enable = true;
      ssh.knownHosts = config.mySnippets.ssh.knownHosts;
    };

    networking.networkmanager.enable = true;

    security = {
      polkit.enable = true;

      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

    services = {
      # ananicy = {
      #   enable = true; # Incompatible/not recommended with gamemode.
      #   package = pkgs.ananicy-cpp;
      #   rulesProvider = pkgs.ananicy-rules-cachyos;
      # };

      bpftune.enable = true;

      cachefilesd = {
        enable = true;

        extraConfig = ''
          brun 20%
          bcull 10%
          bstop 5%
        '';
      };

      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };

      scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };

      udev.extraRules = ''
        ## Allow @audio to write to /dev/cpu_dma_latency.
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root",GROUP="audio", MODE="0660"

        ## Allow users to write to /dev/ntsync.
        # KERNEL=="ntsync", MODE="0644"
      '';
    };

    swapDevices = [
      {
        device = "/.swap";
        priority = 0;
        randomEncryption.enable = true;
        size = 8192;
      }
    ];

    system.configurationRevision = self.rev or self.dirtyRev or null;

    systemd.oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
    };

    zramSwap = {
      enable = lib.mkDefault true;
      algorithm = lib.mkDefault "lz4";
      priority = lib.mkDefault 100;
    };

    myNixOS.programs.njust.enable = true;
  };
}
