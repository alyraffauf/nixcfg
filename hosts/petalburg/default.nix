# Lenovo Yoga 9i Convertible with Intel Core i7-1360P, 16GB RAM, 512GB SSD.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./disko.nix
    ./home.nix
    inputs.nixhw.nixosModules.lenovo-yoga-9i-intel-13th
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  environment.variables.GDK_SCALE = "2";
  networking.hostName = "petalburg";
  system.stateVersion = "24.05";

  ar = {
    apps = {
      firefox.enable = true;
      podman.enable = true;
      steam.enable = true;
    };

    desktop = {
      greetd = {
        enable = true;

        autologin = {
          enable = true;
          user = "aly";
        };
      };

      hyprland.enable = true;
    };

    services.syncthing.enable = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$TitXX3J690cnK41XciNMg/$APKHM/os6FKd9H9aXGxaHaQ8zP5SenO9EO94VYafl43";
    };
  };
}
