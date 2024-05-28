# Lenovo Yoga 9i Convertible with Intel Core i7-1360P, 15GB RAM, 512GB SSD.
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

  networking.hostName = "petalburg"; # Define your hostname.

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    user = {
      aly = {
        enable = true;
        password = "$y$j9T$TitXX3J690cnK41XciNMg/$APKHM/os6FKd9H9aXGxaHaQ8zP5SenO9EO94VYafl43";
      };
      dustin.enable = false;
    };
    desktop = {
      enable = true;
      greetd = {
        enable = true;
        session = lib.getExe pkgs.sway;
        autologin = {
          enable = true;
          user = "aly";
        };
      };
      hyprland.enable = true;
      sway.enable = true;
    };
    apps = {
      steam.enable = true;
    };
    scripts = {
      hoenn.enable = true;
    };
    services = {
      syncthing.enable = true;
      tailscale.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
