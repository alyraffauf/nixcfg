# Custom desktop with AMD Ryzen 5 5600x, 32GB RAM, AMD Rx 7800 XT, and 1TB SSD + 2TB SSD.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./disko.nix
    ./home.nix
    inputs.nixhw.nixosModules.common-amd-cpu
    inputs.nixhw.nixosModules.common-amd-gpu
    inputs.nixhw.nixosModules.common-bluetooth
    inputs.nixhw.nixosModules.common-ssd
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci"];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  environment.variables.GDK_SCALE = "1.25";
  hardware.enableAllFirmware = true;
  networking.hostName = "mandarin";

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

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
          user = "morgan";
        };
      };

      hyprland.enable = true;
      steam.enable = true;
    };

    services.flatpak.enable = true;

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
