{
  config,
  modulesPath,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./secrets.nix
    ./services.nix
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
    firewall.allowedTCPPorts = [2222];
    hostName = "mossdeep";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  programs.ssh.knownHosts = config.mySnippets.ssh.knownHosts;

  system.stateVersion = "24.11";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_62292463";

  myNixOS = {
    profiles = {
      autoUpgrade = {
        enable = true;
        operation = "switch";
      };

      backups.enable = true;
      base.enable = true;
      server.enable = true;

      swap = {
        enable = true;
        size = 2048;
      };
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
