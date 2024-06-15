# Custom Desktop with Ryzen CPU and Nvidia GPU.
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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "mandarin";

  alyraffauf = {
    base = {
      enable = true;
      plymouth.enable = true;
      zramSwap = {enable = true;};
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
    desktop = {
      enable = true;
      greetd = {
        enable = true;
        session = lib.getExe config.programs.hyprland.package;
        autologin = {
          enable = true;
          user = "morgan";
        };
      };
      hyprland.enable = true;
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
      ollama = {
        enable = true;
        gpu = "nvidia";
      };
      tailscale.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
