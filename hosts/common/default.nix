{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./wifi.nix
  ];

  age.secrets = {
    tailscaleAuthKey.file = ../secrets/tailscale/authKeyFile.age;
    wifi.file = ../secrets/wifi.age;
  };

  environment = {
    systemPackages = with pkgs; [
      self.inputs.agenix.packages.${pkgs.system}.default
      inxi
    ];

    variables.FLAKE = "github:alyraffauf/nixcfg";
  };

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

  fileSystems = lib.attrsets.optionalAttrs (config.networking.hostName != "mauville") {
    "/mnt/Archive" = {
      device = "//mauville/Archive";
      fsType = "cifs";
      options = [
        "gid=100"
        "guest"
        "nofail"
        "uid=${toString config.users.users.aly.uid}"
        "x-systemd.after=network.target"
        "x-systemd.after=tailscaled.service"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
      ];
    };

    "/mnt/Media" = {
      device = "//mauville/Media";
      fsType = "cifs";
      options = [
        "gid=100"
        "guest"
        "nofail"
        "uid=${toString config.users.users.aly.uid}"
        "x-systemd.after=network.target"
        "x-systemd.after=tailscaled.service"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
      ];
    };
  };

  home-manager.sharedModules = [
    {
      gtk.gtk3.bookmarks = lib.optionals (config.networking.hostName != "mauville") [
        "file:///mnt/Media"
        "file:///mnt/Archive"
      ];
    }
  ];

  nix.settings = {
    substituters = [
      "https://alyraffauf.cachix.org"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    trusted-users = ["aly"];
  };

  nixpkgs.config.allowUnfree = true; # Allow unfree packages

  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.age.secrets.tailscaleAuthKey.path;
    };

    xserver.xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "02:00";
    flake = "github:alyraffauf/nixcfg";
    operation = "switch";
    persistent = true;
    randomizedDelaySec = "30min";

    rebootWindow = {
      lower = "04:00";
      upper = "06:00";
    };
  };

  time.timeZone = "America/New_York";
}
