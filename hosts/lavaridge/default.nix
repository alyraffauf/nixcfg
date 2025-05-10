{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./backups.nix
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

    b2Options = [
      "allow_other"
      "args2env"
      "cache-dir=${backblazeDirectory}/.rclone-cache"
      "config=${config.age.secrets.rclone-b2.path}"
      "dir-cache-time=1h"
      "nodev"
      "nofail"
      "vfs-cache-mode=full"
      "vfs-write-back=10s"
      "x-systemd.after=network-online.target"
      "x-systemd.automount"
    ];

    b2ProfileOptions = {
      audio = [
        "buffer-size=128M"
        "vfs-cache-max-age=168h"
        "vfs-cache-max-size=10G"
        "vfs-read-ahead=3G"
      ];

      video = [
        "buffer-size=512M"
        "vfs-cache-max-age=336h"
        "vfs-cache-max-size=75G"
        "vfs-read-ahead=5G"
      ];
    };

    mkB2Mount = name: remote: profile: {
      "${backblazeDirectory}/${name}" = {
        device = "b2:${remote}";
        fsType = "rclone";
        options = b2Options ++ b2ProfileOptions.${profile};
      };
    };
  in
    mkB2Mount "Anime" "aly-anime" "video"
    // mkB2Mount "Audiobooks" "aly-audiobooks" "audio"
    // mkB2Mount "Movies" "aly-movies" "video"
    // mkB2Mount "Shows" "aly-shows" "video";

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
      data-share.enable = true;

      forgejo-runner = {
        enable = true;
        number = 3;
      };

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
