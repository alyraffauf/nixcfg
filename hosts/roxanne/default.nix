{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    self.inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd.systemd.enable = lib.mkForce false;

    loader = {
      efi.canTouchEfiVariables = lib.mkForce false;

      systemd-boot = {
        enable = lib.mkForce false;
        configurationLimit = lib.mkDefault 10;
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "roxanne";
    networkmanager.wifi.powersave = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  services = {
    journald.extraConfig = ''
      # Store logs in RAM
      Compress=yes
      Storage=volatile
      SystemMaxUse=50M
    '';

    restic.backups = let
      defaults = {
        inhibitsSleep = true;
        initialize = true;
        passwordFile = config.age.secrets.restic-passwd.path;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
          "--compression max"
        ];

        rcloneConfigFile = config.age.secrets.rclone-b2.path;

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };
    in {
      uptime-kuma =
        defaults
        // {
          backupCleanupCommand = ''
            ${pkgs.systemd}/bin/systemctl start uptime-kuma
          '';

          backupPrepareCommand = ''
            ${pkgs.systemd}/bin/systemctl stop uptime-kuma
          '';

          paths = ["/var/lib/uptime-kuma"];
          repository = "rclone:b2:aly-backups/${config.networking.hostName}/uptime-kuma";
        };
    };

    uptime-kuma = {
      enable = true;
      appriseSupport = true;
      settings.HOST = "0.0.0.0";
    };
  };

  stylix = {
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
  };

  system.stateVersion = "25.05";

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  time.timeZone = "America/New_York";

  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
    priority = lib.mkDefault 100;
  };

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      media-share.enable = true;
    };

    programs = {
      nix.enable = true;
      podman.enable = true;
    };

    services.tailscale.enable = true;
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";
  };
}
