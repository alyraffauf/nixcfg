{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.diskoConfigurations.luks-btrfs-subvolumes
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "1.25";
  networking.hostName = "fallarbor";
  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";
  myHardware.lenovo.thinkpad.X1.gen-9.enable = true;

  myNixOS = {
    desktop = {
      hyprland = {
        # enable = true;
        laptopMonitor = "desc:Chimei Innolux Corporation 0x1417,preferred,auto,1.25";
      };

      kde.enable = true;
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      gaming.enable = true;
      swap.enable = true;
      wifi.enable = true;
      workstation.enable = true;
    };

    programs = {
      firefox.enable = true;
      nix.enable = true;
      steam.enable = true;
      lanzaboote.enable = true;
    };

    services = {
      flatpak.enable = true;
      sddm.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        user = "aly";
      };
    };
  };

  myUsers = {
    aly = {
      enable = true;
      password = "$y$j9T$0p6rc4p5sn0LJ/6XyAGP7.$.wmTafwMMscdW1o8kqqoHJP7U8kF.4WBmzzcPYielR3";
    };

    dustin = {
      enable = true;
      password = "$y$j9T$OXQYhj4IWjRJWWYsSwcqf.$lCcdq9S7m0EAdej9KMHWj9flH8K2pUb2gitNhLTlLG/";
    };
  };
}
