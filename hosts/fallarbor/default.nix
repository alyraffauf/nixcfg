# Framework 13 with 11th gen Intel Core i5, 16GB RAM, 512GB SSD.
{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./home.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking.hostName = "fallarbor";
  system.stateVersion = "24.05";

  ar = {
    apps = {
      firefox.enable = true;
      steam.enable = true;
    };

    base = {
      enable = true;
      sambaAutoMount = false;
    };

    desktop = {
      greetd.enable = true;
      hyprland.enable = true;
    };

    services = {
      flatpak.enable = true;

      syncthing = {
        enable = true;
        syncMusic = false;
      };

      tailscale.enable = true;
    };

    users = {
      aly = {
        enable = true;
        password = "$y$j9T$0p6rc4p5sn0LJ/6XyAGP7.$.wmTafwMMscdW1o8kqqoHJP7U8kF.4WBmzzcPYielR3";
      };

      dustin = {
        enable = true;
        password = "$y$j9T$OXQYhj4IWjRJWWYsSwcqf.$lCcdq9S7m0EAdej9KMHWj9flH8K2pUb2gitNhLTlLG/";
      };
    };
  };
}
