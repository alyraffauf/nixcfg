self: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./firefox
    ./mail
    ./secrets.nix
    ./windowManagers
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
    self.inputs.nur.hmModules.nur
  ];

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      bitwarden-desktop
      browsh
      curl
      fractal
      nicotine-plus
      obsidian
      picard
      tauon
      transmission-remote-gtk
      tuba
      webcord
    ];

    stateVersion = "24.05";
    username = "aly";
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Aly Raffauf";
      userEmail = "aly@raffauflabs.com";

      extraConfig = {
        color.ui = true;
        core.editor = "${lib.getExe config.ar.home.apps.zed.package} --wait";
        github.user = "alyraffauf";
        push.autoSetupRemote = true;
      };
    };

    home-manager.enable = true;
    lazygit.enable = true;

    rbw = {
      enable = true;

      settings = {
        email = "alyraffauf@fastmail.com";
        lock_timeout = 14400;
        pinentry = pkgs.pinentry-gnome3;
      };
    };
  };

  systemd.user.startServices = "legacy"; # Needed for auto-mounting agenix secrets.

  ar.home = {
    apps = {
      backblaze = {
        enable = true;
        keyIdFile = config.age.secrets.backblazeKeyId.path;
        keyFile = config.age.secrets.backblazeKey.path;
      };

      chromium.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      helix.enable = true;
      kitty.enable = true;
      shell.enable = true;
      tmux.enable = true;
      vsCodium.enable = true;
      yazi.enable = true;
      zed. enable = true;
    };

    defaultApps = {
      enable = true;
      editor = config.ar.home.apps.zed.package;
      fileManager = pkgs.xfce.thunar;
    };

    services = {
      gammastep.enable = true;
      randomWallpaper.enable = true;
    };

    theme = {
      enable = true;
      borders.radius = 0;
    };
  };
}
