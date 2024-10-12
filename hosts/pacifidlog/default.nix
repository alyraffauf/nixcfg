# Lenovo Legion Go
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    (import ./../../disko/luks-btrfs-subvolumes.nix {disks = ["/dev/nvme0n1"];})
    self.inputs.jovian.nixosModules.default
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-nix
    self.nixosModules.common-overlays
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-common-amd-cpu
    self.nixosModules.hw-common-amd-gpu
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-laptop-amd-gpu
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];
      systemd.enable = true;
    };

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/etc/secureboot";
    # };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce true;
    };
  };

  environment.variables = {
    FLAKE = lib.mkForce "github:alyraffauf/nixcfg/add-pacifidlog";
    GDK_SCALE = "2";
  };

  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "gamescope-wayland";
    user = "aly";
  };

  jovian.decky-loader = {
    enable = true;
    user = "aly";
  };

  networking.hostName = "pacifidlog";

  nixpkgs.overlays = [
    (final: prev: {
      brave = prev.brave.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};

      obsidian = prev.obsidian.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform=wayland"]
          ["--ozone-platform=wayland --enable-wayland-ime"]
          old.installPhase;
      });

      vscodium = prev.vscodium.override {commandLineArgs = "--enable-wayland-ime";};

      webcord = prev.webcord.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform-hint=auto"]
          ["--ozone-platform-hint=auto --enable-wayland-ime"]
          old.installPhase;
      });
    })
  ];

  services = {
    handheld-daemon = {
      enable = true;
      user = "aly";
    };

    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 18 * 1024;
    }
  ];

  system.stateVersion = "24.11";

  ar = {
    apps = {
      firefox.enable = true;
      steam.enable = true;
    };

    desktop = {
      hyprland.enable = true;
      steam.enable = true;
    };

    laptopMode = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$CXjk5Z9e2PXbSsWh5CK.81$I9Hm/Oa4KcYMqPi8KMBfsEv5NzoXCgaCK5xhyGeikH7";

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
      };
    };
  };
}
