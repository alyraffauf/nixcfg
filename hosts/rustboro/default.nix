# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./home.nix
    ./disko.nix
  ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "rustboro"; # Define your hostname.

  powerManagement.cpuFreqGovernor = "ondemand";

  systemConfig = {
    plymouth.enable = true;
    zramSwap = {
      enable = true;
      size = 100;
    };
  };

  desktopConfig = {
    enable = true;
    windowManagers.hyprland.enable = true;
  };

  apps = {
    flatpak.enable = true;
    steam.enable = false;
  };

  users.users.aly.hashedPassword =
    "$y$j9T$VdtiEyMOegHpcUwgmCVFD0$K8Ne6.zk//VJNq2zxVQ0xE0Wg3LohvAQd3Xm9aXdM15";

  system.stateVersion = "23.11"; # Did you read the comment?
}
