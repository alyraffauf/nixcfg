{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./networking
    ./nix
    ./nixpkgs
    ./plymouth
    ./zramSwap
  ];

  config = lib.mkIf config.ar.base.enable {
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

    environment.systemPackages = with pkgs; [
      inputs.agenix.packages.${pkgs.system}.default
      inxi
    ];

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

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    system.autoUpgrade = {
      allowReboot = true;
      dates = "04:00";
      randomizedDelaySec = "20min";
      enable = true;
      flake = "github:alyraffauf/nixcfg";
      operation = "boot";
      rebootWindow = {
        lower = "02:00";
        upper = "05:00";
      };
    };

    time.timeZone = "America/New_York";
  };
}
