# Framework Laptop 13 with AMD Ryzen 7640U, 32GB RAM, 1TB SSD.

{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./home.nix
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "lavaridge"; # Define your hostname.

  services.fwupd.enable = true;

  services.fprintd.package = pkgs.fprintd.overrideAttrs {
    mesonCheckFlags = [ "--no-suite" "fprintd:TestPamFprintd" ];
  };

  desktopConfig = {
    enable = true;
    windowManagers.hyprland.enable = true;
  };

  apps = {
    flatpak.enable = true;
    steam.enable = true;
  };

  homeLab.virtualization.enable = true;

  systemConfig.plymouth.enable = true;
  systemConfig.zramSwap.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
