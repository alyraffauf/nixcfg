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

  alyraffauf.system = {
    zramSwap = {
      enable = true;
      size = 100;
    };
  };

  alyraffauf.homeLab.enable = true;
  alyraffauf.desktop.enable = true;

  alyraffauf.apps = {
    flatpak.enable = true;
    steam.enable = true;
  };

  system.stateVersion = "23.11";
}
