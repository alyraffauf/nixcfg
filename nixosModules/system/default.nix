{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./plymouth ./power-profiles-daemon ./zramSwap];

  alyraffauf.system.power-profiles-daemon.enable = lib.mkDefault true;

  console = {
    colors = [
      "303446"
      "e78284"
      "a6d189"
      "e5c890"
      "8caaee"
      "f4b8e4"
      "81c8be"
      "b5bfe2"
      "626880"
      "303446"
      "e78284"
      "a6d189"
      "e5c890"
      "8caaee"
      "f4b8e4"
      "81c8be"
      "a5adce"
    ];
    useXkbConfig = true;
  };

  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = config.i18n.defaultLocale;
      LC_IDENTIFICATION = config.i18n.defaultLocale;
      LC_MEASUREMENT = config.i18n.defaultLocale;
      LC_MONETARY = config.i18n.defaultLocale;
      LC_NAME = config.i18n.defaultLocale;
      LC_NUMERIC = config.i18n.defaultLocale;
      LC_PAPER = config.i18n.defaultLocale;
      LC_TELEPHONE = config.i18n.defaultLocale;
      LC_TIME = config.i18n.defaultLocale;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  hardware = {
    bluetooth.enable = true;
    # Add support for logitech unifying receivers.
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    keyboard.qmk.enable = true;

    pulseaudio = {
      enable = lib.mkForce false;
      package = pkgs.pulseaudioFull;
    };
  };

  sound.enable = true;

  networking = {
    networkmanager.enable = true;
  };

  services = {
    logind.extraConfig = ''
      # Don't shutdown when power button is short-pressed
      HandlePowerKey=suspend
      HandlePowerKeyLongPress=poweroff
    '';
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
        workstation = true;
      };
    };
    openssh = {
      enable = true;
      openFirewall = true;
    };
    printing.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    allowReboot = true;
    dates = "04:00";
    randomizedDelaySec="20min";
    enable = true;
    flake = "github:alyraffauf/nixcfg";
    operation = "boot";
    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };

  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
      persistent = true;
      randomizedDelaySec = "60min";
    };
    # Run GC when there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings = {
      auto-optimise-store = false;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nixcache.raffauflabs.com"
        "https://hyprland.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
