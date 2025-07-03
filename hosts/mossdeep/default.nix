{
  config,
  lib,
  modulesPath,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./anubis.nix
    ./proxy.nix
    ./secrets.nix
    ./services.nix
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

  networking = {
    firewall.allowedTCPPorts = [80 443 2222];
    hostName = "mossdeep";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  programs.ssh.knownHosts = config.mySnippets.ssh.knownHosts;
  services.smartd.enable = lib.mkForce false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.11";
  };

  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_62292463";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      backups.enable = true;
      base.enable = true;
      lowResource.enable = true;
    };

    programs = {
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      alycodes = {
        enable = true;
        inherit (config.mySnippets.cute-haus.networkMap.aly-codes) port;
      };

      caddy.enable = true;

      forgejo = {
        enable = true;
        db = "postgresql";
      };

      prometheusNode.enable = true;
      promtail.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.root.enable = true;
}
