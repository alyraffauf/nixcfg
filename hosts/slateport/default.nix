{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    self.nixosModules.disko-btrfs-subvolumes
    self.nixosModules.hardware-lenovo-thinkcentre-m700
    self.nixosModules.locale-en-us
  ];

  networking.hostName = "slateport";
  services.syncthing.guiAddress = "0.0.0.0:8384";
  time.timeZone = "America/New_York";

  stylix = {
    enable = false;
    image = "${self.inputs.wallpapers}/wallhaven-mp886k.jpg";
  };

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "24.05";
  };

  myDisko.installDrive = "/dev/sda";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      media-share.enable = true;
      server.enable = true;
      wifi.enable = true;
    };

    programs = {
      nix.enable = true;
      podman.enable = true;
      systemd-boot.enable = true;
    };

    services = {
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
