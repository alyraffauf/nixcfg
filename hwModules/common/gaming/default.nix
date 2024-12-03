{lib, ...}: {
  boot.kernel.sysctl = {
    # Improved file monitoring
    "fs.inotify.max_user_instances" = lib.mkOverride 100 8192; # Re-use the default from Bazzite even though the default NixOS value is higher.
    # "fs.inotify.max_user_watches" = lib.mkOverride 100 524288;

    # Disable watchdogs for maximum performance at the cost of resiliency
    "kernel.nmi_watchdog" = lib.mkOverride 100 0;
    "kernel.soft_watchdog" = lib.mkDefault 0;
    # "kernel.split_lock_mitigate" = lib.mkOverride 100 0;
    "kernel.watchdog" = lib.mkDefault 0;

    # Network optimizations
    "net.core.default_qdisc" = lib.mkDefault "fq";
    "net.ipv4.tcp_congestion_control" = lib.mkDefault "bbr";
    "net.ipv4.tcp_mtu_probing" = lib.mkForce 1;

    # Memory management
    "vm.dirty_background_bytes" = lib.mkDefault 134217728;
    "vm.dirty_bytes" = lib.mkDefault 268435456;
    # "vm.max_map_count" = lib.mkOverride 100 2147483642;
    "vm.page-cluster" = lib.mkDefault 0;
    "vm.swappiness" = lib.mkDefault 180;
    "vm.watermark_boost_factor" = lib.mkDefault 0;
    "vm.watermark_scale_factor" = lib.mkDefault 125;
  };

  services.udev.extraRules = ''
    # Significantly improved I/O performance
    ## SSD
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"

    ## NVME
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"

    ## MicroSD
    ACTION=="add|change", KERNEL=="mmcblk[0-9]p[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"

    ## HDD
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';

  zramSwap.algorithm = "lz4";
}
