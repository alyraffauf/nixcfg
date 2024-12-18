# Framework 13 with 11th gen Intel Core i5, 16GB RAM, 512GB SSD.
{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-nix
    self.nixosModules.common-pkgs
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-framework-13-intel-11th
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  environment.variables.GDK_SCALE = "1.5";
  networking.hostName = "fallarbor";
  system.stateVersion = "24.05";

  ar = {
    apps = {
      firefox.enable = true;
      steam.enable = true;
    };

    desktop = {
      greetd = {
        enable = true;
        session = lib.getExe config.programs.hyprland.package;
      };

      hyprland.enable = true;
    };

    laptopMode = true;
    services.flatpak.enable = true;

    users = {
      aly = {
        enable = true;
        password = "$y$j9T$0p6rc4p5sn0LJ/6XyAGP7.$.wmTafwMMscdW1o8kqqoHJP7U8kF.4WBmzzcPYielR3";

        syncthing = {
          enable = true;
          certFile = config.age.secrets.syncthingCert.path;
          keyFile = config.age.secrets.syncthingKey.path;
          syncMusic = false;
        };
      };

      dustin = {
        enable = true;
        password = "$y$j9T$OXQYhj4IWjRJWWYsSwcqf.$lCcdq9S7m0EAdej9KMHWj9flH8K2pUb2gitNhLTlLG/";
      };
    };
  };
}
