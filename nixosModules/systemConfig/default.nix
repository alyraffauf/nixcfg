{ config, pkgs, lib, ... }:

{
  imports =
    [ ./network.nix ./plymouth ./power-profiles-daemon ./zramSwap ];

  systemConfig.power-profiles-daemon.enable = lib.mkDefault true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  hardware = {
    # Enable Bluetooth connections.
    bluetooth.enable = true;
    # Add support for logitech unifying receivers.
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    # Add support for configuring QMK keyboards with Via.
    keyboard.qmk.enable = true;

    pulseaudio = {
      enable = lib.mkForce false;
      # Enables extra codecs like aptx.
      package = pkgs.pulseaudioFull;
    };
  };

  sound.enable = true;

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
    enable = true;
    flake = "github:alyraffauf/nixcfg";
    operation = "boot";
    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };

  nix = {
    gc = {
      # Delete generations older than 7 days.
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
      randomizedDelaySec = "60min";
    };
    # Run GC when there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings = {
      # Automatically optimize the Nix store in the background.
      auto-optimise-store = true;
      # Enable experimental `nix` command and flakes.
      experimental-features = [ "nix-command" "flakes" ];
      substituters =
        [ "https://nixcache.raffauflabs.com" "https://cache.nixos.org/" ];
      trusted-public-keys = [
        "nixcache.raffauflabs.com:yFIuJde/izA4aUDI3MZmBLzynEsqVCT1OfCUghOLlt8="
      ];
    };
  };
}
