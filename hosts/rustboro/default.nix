# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

  networking.hostName = "rustboro"; # Define your hostname.

  powerManagement.cpuFreqGovernor = "ondemand";

  home-manager.users.aly = import ../../home/aly-hyprland.nix;

  desktopConfig = {
    enable = true;
    windowManagers.hyprland.enable = true;
  };

  programs = {
    flatpakSupport.enable = true;
  };

  systemConfig.plymouth.enable = true;
  systemConfig.zramSwap.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
