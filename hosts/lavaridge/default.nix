# Framework Laptop 13 with AMD Ryzen 7640U, 32GB RAM, 1TB SSD.
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
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

  services = {
    fwupd.enable = true;
    fprintd.package = pkgs.fprintd.overrideAttrs {
      mesonCheckFlags = ["--no-suite" "fprintd:TestPamFprintd"];
    };
  };

  systemConfig = {
    plymouth.enable = true;
    zramSwap = {enable = true;};
  };

  desktopConfig = {
    enable = true;
    windowManagers.hyprland.enable = true;
  };

  apps = {
    flatpak.enable = true;
    podman.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
  };

  users.users.aly.hashedPassword = "$y$j9T$O9NgTk6iRfh3mxiRDvfdm1$BjvsAKYEMB3C28652FF15cj/i.3TgQAObQvR0rN1E6C";

  system.stateVersion = "23.11"; # Did you read the comment?
}
