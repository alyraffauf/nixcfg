# Custom desktop with AMD Ryzen 5 5600x, 32GB RAM, AMD Rx 7800 XT, and 1TB SSD + 2TB SSD.
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

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking.hostName = "mandarin";

  system.stateVersion = "24.05";

  ar = {
    apps = {
      podman.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };

    base.enable = true;

    desktop = {
      enable = true;

      greetd = {
        enable = true;

        autologin = {
          enable = true;
          user = "morgan";
        };
      };

      hyprland.enable = true;
      steam.enable = true;
    };

    services = {
      flatpak.enable = true;

      ollama = {
        enable = true;
        gpu = "amd";
      };

      tailscale.enable = true;
    };

    users = {
      aly = {
        enable = true;
        password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";
      };

      morgan = {
        enable = true;
        password = "$y$j9T$frYXYFwo4KuPWEqilfPCN1$CtRMMK4HFLKu90qkv1cCkvp1UdJocUbkySQlVElwkM2";
      };
    };
  };
}
