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

  gtk = let
    nordCss = ''
      @define-color window_bg_color #2E3440;
      @define-color window_fg_color #ECEFF4;
      @define-color view_bg_color #434C5E;
      @define-color view_fg_color @window_fg_color;
      @define-color accent_bg_color #8FBCBB;
      @define-color accent_fg_color #ffffff;
      @define-color accent_color @accent_bg_color;
      @define-color headerbar_bg_color #3B4252;
      @define-color headerbar_backdrop_color @window_bg_color;
      @define-color headerbar_fg_color @window_fg_color;
      @define-color popover_bg_color #4C566A;
      @define-color popover_fg_color @view_fg_color;
      @define-color dialog_bg_color @popover_bg_color;
      @define-color dialog_fg_color @popover_fg_color;
      @define-color card_bg_color @popover_bg_color;
      @define-color card_fg_color @window_fg_color;
      @define-color sidebar_bg_color @headerbar_bg_color;
      @define-color sidebar_fg_color @window_fg_color;
      @define-color sidebar_backdrop_color @window_bg_color;
      @define-color sidebar_shade_color rgba(0,0,0,0.25);
      decoration {
        box-shadow: 0 3px 12px 1px rgba(0, 0, 0, 0.7), 0 0 0 1px shade(@headerbar_bg_color,1.3);
      }
      decoration:backdrop {
        box-shadow: 0 3px 12px 1px transparent, 0 2px 6px 2px rgba(0, 0, 0, 0.4), 0 0 0 1px shade(@headerbar_bg_color,1.1);
      }
      .tiled decoration, .tiled-top decoration, .tiled-bottom decoration, .tiled-right decoration, .tiled-left decoration {
        box-shadow: 0 0 0 1px shade(@headerbar_bg_color,1.1), 0 0 0 20px transparent;
      }
      messagedialog.csd decoration, .csd.popup decoration, .maximized .csd.popup decoration {
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.8), 0 0 0 1px alpha(shade(@headerbar_bg_color,1.3),0.9);
      }
      .maximized .csd.popup decoration {
        border-radius: 6px;
      }
      .maximized decoration, .fullscreen decoration {
        border-radius: 0;
        box-shadow: none;
      }
      .ssd decoration {
        box-shadow: 0 0 0 1px shade(@headerbar_bg_color,1.3);
      }
      .ssd decoration:backdrop {
        box-shadow: 0 0 0 1px shade(@headerbar_bg_color,1.1);
      }
      .ssd.maximized decoration, .ssd.maximized decoration:backdrop {
        box-shadow: none;
      }
      .solid-csd decoration {
        box-shadow: inset 0 0 0 5px alpha(currentColor,0.5), inset 0 0 0 4px @headerbar_bg_color, inset 0 0 0 1px alpha(currentColor,0.5);
      }
      .solid-csd decoration:backdrop {
        box-shadow: inset 0 0 0 3px @window_bg_color;
      }

      .titlebar, headerbar {
        border-bottom-color: alpha(currentColor,0.15);
      }
      .titlebar:backdrop, headerbar:backdrop {
        border-bottom-color: alpha(currentColor,0.2);
      }

      button.titlebutton,
      windowcontrols > button {
        color: transparent;
        min-width: 18px;
        min-height: 18px;
      }

      button.titlebutton:backdrop {
        opacity: 0.5;
      }

      windowcontrols > button {
        border-radius: 100%;
        padding: 0;
        margin: 0 5px;
      }
      windowcontrols > button > image {
        padding: 0;
      }

      button.titlebutton.close,
      windowcontrols > button.close {
        background-color: #BF616A;
      }
      button.titlebutton.close:hover,
      windowcontrols > button.close:hover {
        background-color: #d5979d;
      }
      button.titlebutton.maximize,
      windowcontrols > button.maximize {
        background-color: #A3BE8C;
      }
      button.titlebutton.maximize:hover,
      windowcontrols > button.maximize:hover {
        background-color: #cadabd;
      }
      button.titlebutton.minimize,
      windowcontrols > button.minimize {
        background-color: #EBCB8B;
      }
      button.titlebutton.minimize:hover,
      windowcontrols > button.minimize:hover {
        background-color: #f6e8cc;
      }
      button.titlebutton.close:backdrop, button.titlebutton.maximize:backdrop, button.titlebutton.minimize:backdrop,
      windowcontrols > button.close:backdrop,
      windowcontrols > button.maximize:backdrop,
      windowcontrols > button.minimize:backdrop {
        background-color: #4C566A;
      }
      button.titlebutton.close:backdrop:hover, button.titlebutton.maximize:backdrop:hover, button.titlebutton.minimize:backdrop:hover,
      windowcontrols > button.close:backdrop:hover,
      windowcontrols > button.maximize:backdrop:hover,
      windowcontrols > button.minimize:backdrop:hover {
        background-color: #6d7a96;
      }
      button.titlebutton.close:active, button.titlebutton.maximize:active, button.titlebutton.minimize:active,
      windowcontrols > button.close:active,
      windowcontrols > button.maximize:active,
      windowcontrols > button.minimize:active {
        box-shadow: inset 0 0 0 3px rgba(0, 0, 0, 0.3);
      }

      notebook > header tab:not(:backdrop):checked.reorderable-page,
      tabbar tab:not(:backdrop):checked {
        background-color: @headerbar_bg_color;
      }

      .nautilus-window .sidebar {
        background-color: @view_bg_color;
      }
      .nautilus-window .sidebar:backdrop {
        background-color: @window_bg_color;
      }'';
  in {
    # gtk3.extraCss = nordCss;
    # gtk4.extraCss = nordCss;
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
    home-manager.enable = true;

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
    };

    services = {
      gammastep.enable = true;
      randomWallpaper.enable = true;
    };

    theme = {
      enable = true;

      colors = {
        text = "#FFFFFF";
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
