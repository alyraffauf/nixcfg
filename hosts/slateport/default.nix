{
  config,
  self,
  ...
}: {
  imports = [
    ./anubis.nix
    ./backups.nix
    ./home.nix
    ./oci.nix
    ./proxy.nix
    ./secrets.nix
    ./services.nix
    self.nixosModules.disko-btrfs-subvolumes
    self.nixosModules.hardware-lenovo-thinkcentre-m700
    self.nixosModules.locale-en-us
  ];

  networking.hostName = "slateport";

  stylix = {
    enable = false;
    image = "${self.inputs.wallpapers}/wallhaven-mp886k.jpg";
  };

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.05";
  };

  time.timeZone = "America/New_York";
  myDisko.installDrive = "/dev/sda";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
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

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";
  };
}
