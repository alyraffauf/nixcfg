# Steam Deck OLED
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
    self.nixosModules.default
    inputs.jovian.nixosModules.default
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "mossdeep"; # Define your hostname.

  services = {
    fwupd.enable = true;
  };

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    user = {
      aly = {
        enable = true;
        password = "$y$j9T$koxhEzkA4pYLsyIqZBTWM0$N8VW.JTM.HZZgNm7XgTxTXRzvYd7veA7TojG0gKOzO2";
      };
      dustin.enable = false;
    };
    desktop = {
      enable = true;
      hyprland.enable = true;
    };
    apps = {
      steam.enable = true;
    };
    scripts = {
      hoenn.enable = true;
    };
    services = {
      flatpak.enable = true;
      syncthing.enable = true;
      tailscale.enable = true;
    };
  };

  jovian = {
    steam = {
      user = "aly";
      enable = true;
      autoStart = true;
      desktopSession = "hyprland";
    };
    decky-loader = {
      user = "aly";
      enable = true;
    };
    devices.steamdeck.enable = true;
    steamos.useSteamOSConfig = true;
  };

  system.stateVersion = "24.05";
}
