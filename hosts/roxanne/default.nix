{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./backups.nix
    ./home.nix
    ./secrets.nix
    self.inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  environment.systemPackages = [pkgs.rclone];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

    "/Audiobooks" = {
      device = "b2:aly-audiobooks";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "cache-dir=/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=2160h" # Cache files for up to 3 months (2160 hours)
        "vfs-cache-max-size=1G" # Cache up to 100GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=512M" # Preload 512MB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };

    "/Movies" = {
      device = "b2:aly-movies";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "cache-dir=/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=2160h" # Cache files for up to 3 months (2160 hours)
        "vfs-cache-max-size=10G" # Cache up to 100GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=512M" # Preload 512MB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };

    "/Shows" = {
      device = "b2:aly-shows";
      fsType = "rclone";

      options = [
        "allow_other"
        "args2env"
        "cache-dir=/.rclone-cache"
        "config=${config.age.secrets.rclone-b2.path}"
        "nodev"
        "nofail"
        "vfs-cache-max-age=2160h" # Cache files for up to 3 months (2160 hours)
        "vfs-cache-max-size=10G" # Cache up to 100GB
        "vfs-cache-mode=full" # Enables full read/write caching
        "vfs-read-ahead=512M" # Preload 512MB of data for smoother playback
        "vfs-write-back=10s" # Delay write operations by 10 seconds
        "x-systemd.after=network.target"
        "x-systemd.automount"
      ];
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "roxanne";
    networkmanager.wifi.powersave = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    journald.extraConfig = ''
      # Store logs in RAM
      Compress=yes
      Storage=volatile
      SystemMaxUse=50M
    '';

    tautulli.enable = true;

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
