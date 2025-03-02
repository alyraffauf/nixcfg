# Framework 13 with 11th gen Intel Core i5, 16GB RAM, 512GB SSD.
{
  config,
  self,
  ...
}: {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.hardware-framework-13-intel-11th
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "1.5";
  networking.hostName = "fallarbor";
  system.stateVersion = "24.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    desktop = {
      hyprland = {
        # enable = true;
        laptopMonitor = "desc:BOE 0x095F,preferred,auto,1.566667";
      };

      kde.enable = true;
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      gaming.enable = true;
      wifi.enable = true;
      workstation.enable = true;
    };

    programs = {
      firefox.enable = true;
      nix.enable = true;
      steam.enable = true;
      systemd-boot.enable = true;
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
