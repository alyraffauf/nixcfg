{self, ...}: {
  imports = [
    ./secrets.nix
    ./services.nix
    self.diskoConfigurations.btrfs-subvolumes
    self.nixosModules.locale-en-us
  ];

  networking.hostName = "slateport";
  powerManagement.powertop.enable = true;
  system.stateVersion = "25.11";
  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/sda";
  myHardware.lenovo.thinkcentre.m700.enable = true;

  myNixOS = {
    profiles = {
      autoUpgrade = {
        enable = true;
        operation = "switch";
      };

      backups.enable = true;
      base.enable = true;
      btrfs.enable = true;
      data-share.enable = true;
      media-share.enable = true;
      server.enable = true;
      swap.enable = true;
      wifi.enable = true;
    };

    programs = {
      nix.enable = true;
      podman.enable = true;
      systemd-boot.enable = true;
    };

    services = {
      caddy.enable = true;
      homebridge.enable = true;
      prometheusNode.enable = true;
      promtail.enable = true;
      tailscale.enable = true;
    };
  };

  myUsers.root.enable = true;
}
