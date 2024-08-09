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
        core.editor = "${lib.getExe config.programs.vscode.package} --wait";
        github.user = "alyraffauf";
        push.autoSetupRemote = true;
      };
    };

    gitui.enable = true;
    helix.settings.theme = "rose-pine-moon";
    home-manager.enable = true;
    kitty.theme = "Rosé Pine Moon";

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

      chromium.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      helix.enable = true;
      keepassxc.enable = true;
      kitty.enable = true;
      shell.enable = true;
      tmux.enable = true;
      vsCodium.enable = true;
      yazi.enable = true;

      zed = {
        enable = true;
        package = unstable.zed-editor;

        settings = {
          auto_install_extensions = {nord = true;};

          theme = {
            dark = "Rosé Pine Moon";
            light = "Rosé Pine Dawn";
            mode = "system";
          };
        };
      };
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

      colors = {
        text = "#e0def4";
        background = "#2a273f";
        primary = "#3e8fb0";
        secondary = "#f6c177";
        inactive = "#393552";
        shadow = "#232136";
      };

      wallpaper = "${config.xdg.dataHome}/backgrounds/wallhaven-6d7xmx.jpg";
    };
  };
}
