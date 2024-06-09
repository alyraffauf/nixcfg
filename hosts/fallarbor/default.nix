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
    self.nixosModules.default
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "fallarbor"; # Define your hostname.

  age.secrets = {
    syncthingCert.file = ../../secrets/hosts + "/${config.networking.hostName}/syncthing/cert.age";
    syncthingKey.file = ../../secrets/hosts + "/${config.networking.hostName}/syncthing/key.age";
  };

  services = {
    fwupd.enable = true;
    syncthing = {
      cert = config.age.secrets.syncthingCert.path;
      key = config.age.secrets.syncthingKey.path;
    };
  };

  alyraffauf = {
    services = {
      flatpak.enable = true;
      syncthing = {
        enable = true;
        syncMusic = false;
      };
      tailscale.enable = true;
    };
    system = {
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    user = {
      aly = {
        enable = true;
        password = "$y$j9T$0p6rc4p5sn0LJ/6XyAGP7.$.wmTafwMMscdW1o8kqqoHJP7U8kF.4WBmzzcPYielR3";
      };
      dustin = {
        enable = true;
        password = "$y$j9T$OXQYhj4IWjRJWWYsSwcqf.$lCcdq9S7m0EAdej9KMHWj9flH8K2pUb2gitNhLTlLG/";
      };
    };
    desktop = {
      enable = true;
      greetd.enable = true;
      hyprland.enable = true;
    };
    apps = {
      steam.enable = true;
    };
    scripts = {
      hoenn.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
