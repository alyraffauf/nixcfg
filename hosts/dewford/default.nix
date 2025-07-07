{
  config,
  lib,
  modulesPath,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./secrets.nix
    ./stylix.nix
    "${modulesPath}/profiles/qemu-guest.nix"
    self.diskoConfigurations.lvm-ext4
    self.nixosModules.locale-en-us
  ];

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "sr_mod"
      "virtio_pci"
      "virtio_scsi"
      "xhci_pci"
    ];

    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    htop
    rclone
    zellij
  ];

  fileSystems = let
    b2Options = [
      "allow_other"
      "args2env"
      "cache-dir=/mnt/Backblaze/.rclone-cache"
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
        "vfs-cache-max-size=15G"
        "vfs-read-ahead=1G"
      ];

      video = [
        "buffer-size=512M"
        "vfs-cache-max-age=336h"
        "vfs-cache-max-size=50G"
        "vfs-read-ahead=3G"
      ];
    };

    mkB2Mount = name: remote: profile: {
      "/mnt/Backblaze/${name}" = {
        device = "b2:${remote}";
        fsType = "rclone";
        options = b2Options ++ b2ProfileOptions.${profile};
      };
    };
  in
    mkB2Mount "Anime" "aly-anime" "video"
    // mkB2Mount "Audiobooks" "aly-audiobooks" "audio"
    // mkB2Mount "Movies" "aly-movies" "video"
    // mkB2Mount "Music" "aly-music" "audio"
    // mkB2Mount "Shows" "aly-shows" "video";

  networking.hostName = "dewford";
  nixpkgs.hostPlatform = "x86_64-linux";
  programs.ssh.knownHosts = config.mySnippets.ssh.knownHosts;
  services.smartd.enable = lib.mkForce false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "25.11";
  };

  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/vda";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      backups.enable = true;
      base.enable = true;
      data-share.enable = true;
      server.enable = true;
      media-share.enable = true;
    };

    programs.nix.enable = true;

    services = {
      caddy.enable = true;
      plex.enable = true;
      prometheusNode.enable = true;
      promtail.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.root.enable = true;
}
