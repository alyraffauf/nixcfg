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
    ../common.nix
    ./disko.nix
    ./home.nix
    inputs.nixhw.nixosModules.framework-13-amd-7000
  ];

  age.secrets = {
    syncthingCert.file = ../../secrets/syncthing/lavaridge/cert.age;
    syncthingKey.file = ../../secrets/syncthing/lavaridge/key.age;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  environment.variables.GDK_SCALE = "1.5";
  networking.hostName = "lavaridge";
  system.stateVersion = "24.05";

  ar = {
    apps = {
      firefox.enable = true;
      podman.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };

    desktop = {
      greetd = {
        enable = true;

        autologin = {
          enable = true;
          user = "aly";
        };
      };

      hyprland.enable = true;
    };

    users.aly = {
      enable = true;
      password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
      };
    };
  };
}
