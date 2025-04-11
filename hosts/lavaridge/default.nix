{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-framework-13-intel-11th
    self.nixosModules.locale-en-us
  ];

  environment.systemPackages = [pkgs.rclone];

  fileSystems = let
    backblazeDirectory = "/mnt/Backblaze";

    options = [
      "allow_other"
      "args2env"
      "buffer-size=256M"
      "cache-dir=${backblazeDirectory}/.rclone-cache"
      "config=${config.age.secrets.rclone-b2.path}"
      "nodev"
      "nofail"
      "vfs-cache-max-age=2160h" # Cache files for up to 3 months (2160 hours)
      "vfs-cache-max-size=25G" # Cache up to 25GB
      "vfs-cache-mode=full" # Enables full read/write caching
      "vfs-read-ahead=3G" # Preload 3GB of data for smoother playback
      "vfs-write-back=10s" # Delay write operations by 10 seconds
      "x-systemd.after=network.target"
      "x-systemd.automount"
    ];
  in {
    "${backblazeDirectory}/Audiobooks" = {
      inherit options;
      device = "b2:aly-audiobooks";
      fsType = "rclone";
    };

    "${backblazeDirectory}/Movies" = {
      inherit options;
      device = "b2:aly-movies";
      fsType = "rclone";
    };

    "${backblazeDirectory}/Shows" = {
      inherit options;
      device = "b2:aly-shows";
      fsType = "rclone";
    };
  };

  networking.hostName = "lavaridge";
  services.xserver.xkb.options = "ctrl:nocaps";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      media-share.enable = true;
      server.enable = true;
      swap.enable = true;
      wifi.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$VMCXwk0X5m6xW6FGLc39F/$r9gmyeB70RCq3k4oLPHFZyy7wng6WyX2xYMKLO/A.rB";
  };
}
