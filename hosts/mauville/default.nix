# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix ./home.nix];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mauville"; # Define your hostname.

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {
        enable = true;
        size = 100;
      };
    };
    user = {
      aly.enable = true;
      dustin.enable = true;
    };
    desktop = {
      enable = true;
      hyprland.enable = true;
    };
    homeLab.enable = true;
    apps = {
      steam.enable = true;
      podman.enable = true;
      virt-manager.enable = true;
    };
  };

  system.stateVersion = "23.11";
}
