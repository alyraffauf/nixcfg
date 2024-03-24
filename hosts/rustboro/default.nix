# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ../../users/aly.nix
      ../../system
      ../../modules/plymouth.nix
      # ../../modules/kde.nix
      # ../../modules/sway.nix
      ../../modules/hyprland.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

  networking.hostName = "rustboro"; # Define your hostname.

  powerManagement.cpuFreqGovernor = "ondemand";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}