self: {
  config,
  lib,
  pkgs,
  ...
}: let
  unstable = import self.inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
in {
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

    file = {
      "${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
        General.LastActiveDatabase = "${config.home.homeDirectory}/sync/Passwords.kdbx";
      };
    };

    packages = [
      pkgs.bitwarden-desktop
      pkgs.browsh
      pkgs.curl
      pkgs.fractal
      pkgs.git
      pkgs.nicotine-plus
      pkgs.obsidian
      pkgs.picard
      pkgs.tauon
      pkgs.transmission-remote-gtk
      pkgs.webcord
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
        core.editor = "${lib.getExe unstable.zed-editor} --wait";
        github.user = "alyraffauf";
        push.autoSetupRemote = true;
      };
    };

    gitui.enable = true;
    home-manager.enable = true;

    oh-my-posh = {
      enable = true;
      useTheme = "zash";
    };

    rbw = {
      enable = true;
      package = pkgs.rbw;

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

      bash.enable = true;
      chromium.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      helix.enable = true;
      keepassxc.enable = true;
      kitty.enable = true;
      tmux.enable = true;
      vsCodium.enable = true;
      yazi.enable = true;

      zed = {
        enable = true;
        package = unstable.zed-editor;
      };
    };

    defaultApps.enable = true;

    services = {
      gammastep.enable = true;
      randomWallpaper.enable = true;
    };

    theme = {
      enable = true;
      wallpaper = "${config.xdg.dataHome}/backgrounds/wallhaven-5g6g33.jpg";
    };
  };
}
