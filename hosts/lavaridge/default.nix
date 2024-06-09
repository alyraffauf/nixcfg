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
    self.nixosModules.default
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest Linux kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "lavaridge"; # Define your hostname.

  age.secrets = {
    syncthingCert.file = ../../secrets/hosts + "/${config.networking.hostName}/syncthing/cert.age";
    syncthingKey.file = ../../secrets/hosts + "/${config.networking.hostName}/syncthing/key.age";
  };

  services = {
    fwupd.enable = true;
    syncthing = {
      cert = config.age.secrets.syncthingCert.path;
      key = config.age.secrets.syncthingKey.path;
    };
  };

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {enable = true;};
    };
    user = {
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
