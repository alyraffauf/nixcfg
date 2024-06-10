# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.
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
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "rustboro"; # Define your hostname.

  age.secrets = {
    syncthingCert.file = ../../secrets/hosts + "/${config.networking.hostName}/syncthing/cert.age";
    syncthingKey.file = ../../secrets/hosts + "/${config.networking.hostName}/syncthing/key.age";
  };

  services.syncthing = {
    cert = config.age.secrets.syncthingCert.path;
    key = config.age.secrets.syncthingKey.path;
  };

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {
        enable = true;
        size = 100;
      };
    };
    user = {
      aly = {
        enable = true;
        password = "$y$j9T$VdtiEyMOegHpcUwgmCVFD0$K8Ne6.zk//VJNq2zxVQ0xE0Wg3LohvAQd3Xm9aXdM15";
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
      sway.enable = false;
      hyprland.enable = true;
    };
    apps = {
      steam.enable = false;
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
