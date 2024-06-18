# Framework Laptop 13 with AMD Ryzen 7640U, 32GB RAM, 1TB SSD.
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
  };

  alyraffauf = {
    base = {
      enable = true;
      sambaAutoMount = true;
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    users = {
      aly = {
        enable = true;
        password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";
      };
      dustin.enable = false;
    };
    desktop = {
      enable = true;
      greetd = {
        enable = true;
        session = lib.getExe config.programs.hyprland.package;
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
      podman.enable = true;
      virt-manager.enable = true;
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
