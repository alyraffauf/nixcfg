# Custom desktop with AMD Ryzen 5 2600, 16GB RAM, AMD Rx 6700, and 1TB SSD + 2TB HDD.

{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ./home.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mauville"; # Define your hostname.

  services.xserver = {
    # Prevent system sleep after reboot to login screen.
    displayManager.gdm.autoSuspend = false;
    # Add AMDGPU driver.
    videoDrivers = [ "amdgpu" ];
  };

  hardware.opengl = {
    # Add ROCM annd AMD Vulkan driver.
    extraPackages = with pkgs; [ rocmPackages.clr.icd amdvlk ];
    # Add support for 32bit apps.
    driSupport32Bit = true;
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  systemConfig = {
    zramSwap.enable = true;
  };

  homeLab.enable = true;
  desktopConfig.enable = true;

  apps = {
    flatpak.enable = true;
    steam.enable = true;
  };

  system.stateVersion = "23.11";
}
