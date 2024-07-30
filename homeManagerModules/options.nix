{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  options.ar.home = {
    apps = {
      alacritty.enable = lib.mkEnableOption "Alacritty terminal.";

      backblaze = {
        enable = lib.mkEnableOption "Backblaze-b2 client with declarative authentication.";

        keyIdFile = lib.mkOption {
          description = "Backblaze key ID.";
          default = null;
          type = lib.types.nullOr lib.types.str;
        };

        keyFile = lib.mkOption {
          description = "Backblaze application key.";
          default = null;
          type = lib.types.nullOr lib.types.str;
        };
      };

      bash.enable = lib.mkEnableOption "Bash defaults.";

      chromium = {
        enable = lib.mkEnableOption "Chromium-based browser with default extensions.";
        package = lib.mkPackageOption pkgs "brave" {};
      };

      emacs.enable = lib.mkEnableOption "Emacs text editor.";
      fastfetch.enable = lib.mkEnableOption "Fastfetch.";
      firefox.enable = lib.mkEnableOption "Firefox web browser.";
      fuzzel.enable = lib.mkEnableOption "Fuzzel app launcher.";
      helix.enable = lib.mkEnableOption "Helix text editor.";

      keepassxc = {
        enable = lib.mkEnableOption "KeePassXC password manager.";

        settings = lib.mkOption {
          description = "KeePassXC settings.";
          default = {};
          type = lib.types.attrs;
        };
      };

      kitty.enable = lib.mkEnableOption "Kitty terminal.";
      librewolf.enable = lib.mkEnableOption "Librewolf web browser.";
      mako.enable = lib.mkEnableOption "Mako notification daemon.";

      nemo.enable = lib.mkOption {
        description = "Cinnamon Nemo file manager.";
        default = cfg.defaultApps.fileManager == pkgs.cinnamon.nemo;
        type = lib.types.bool;
      };

      rofi.enable = lib.mkEnableOption "Rofi launcher.";
      swaylock.enable = lib.mkEnableOption "Swaylock screen locker.";

      thunar.enable = lib.mkOption {
        description = "Thunar file manager.";
        default = cfg.defaultApps.fileManager == pkgs.xfce.thunar;
        type = lib.types.bool;
      };

      tmux.enable = lib.mkEnableOption "Tmux shell session manager.";
      vsCodium.enable = lib.mkEnableOption "VSCodium text editor.";
      waybar.enable = lib.mkEnableOption "Waybar wayland panel.";
      wlogout.enable = lib.mkEnableOption "Wlogout session prompt.";
      yazi.enable = lib.mkEnableOption "Yazi terminal file manager.";

      zed = {
        enable = lib.mkEnableOption "Zed text editor.";
        package = lib.mkPackageOption pkgs "zed-editor" {};

        keymaps = lib.mkOption {
          description = "Zed keymaps.";
          default = [];
          type = lib.types.listOf lib.types.attrs;
        };

        settings = lib.mkOption {
          description = "Zed settings.";
          default = {};
          type = lib.types.attrs;
        };
      };
    };

    defaultApps = {
      enable = lib.mkEnableOption "Declaratively set default apps and file associations.";
      audioPlayer = lib.mkPackageOption pkgs "audio player" {default = ["celluloid"];};
      editor = lib.mkPackageOption pkgs "text editor" {default = ["vscodium"];};
      fileManager = lib.mkPackageOption pkgs "file manager" {default = ["cinnamon" "nemo"];};
      imageViewer = lib.mkPackageOption pkgs "image viewer" {default = ["gnome" "eog"];};
      pdfViewer = lib.mkPackageOption pkgs "pdf viewer" {default = ["evince"];};
      terminal = lib.mkPackageOption pkgs "terminal emulator" {default = ["kitty"];};
      terminalEditor = lib.mkPackageOption pkgs "terminal text editor" {default = ["vim"];};
      videoPlayer = lib.mkPackageOption pkgs "video player" {default = ["celluloid"];};
      webBrowser = lib.mkPackageOption pkgs "web browser" {default = ["firefox"];};
    };

    desktop = {
      autoSuspend = lib.mkOption {
        description = "Whether to autosuspend on idle.";
        default = cfg.desktop.hyprland.enable || cfg.desktop.sway.enable;
        type = lib.types.bool;
      };

      randomWallpaper = lib.mkOption {
        description = "Whether to enable random wallpaper script.";
        default = cfg.desktop.hyprland.enable || cfg.desktop.sway.enable;
        type = lib.types.bool;
      };

      hyprland = {
        enable = lib.mkOption {
          description = "Hyprland with full desktop session components.";
          default = osConfig.ar.desktop.hyprland.enable;
          type = lib.types.bool;
        };

        laptopMonitors = lib.mkOption {
          description = "List of internal laptop monitors.";
          default = [];
          type = lib.types.listOf lib.types.str;
        };

        monitors = lib.mkOption {
          description = "List of external monitors.";
          default = [];
          type = lib.types.listOf lib.types.str;
        };

        redShift = lib.mkOption {
          description = "Whether to redshift display colors at night.";
          default = cfg.desktop.hyprland.enable;
          type = lib.types.bool;
        };

        windowManagerBinds = lib.mkOption {
          description = "Default binds for window management.";
          default = {
            down = "d";
            left = "l";
            right = "r";
            up = "u";
            h = "l";
            j = "d";
            k = "u";
            l = "r";
          };
          type = lib.types.attrs;
        };

        tabletMode = {
          enable = lib.mkEnableOption "Tablet mode for hyprland.";

          autoRotate = lib.mkOption {
            description = "Whether to autorotate screen.";
            default = cfg.desktop.hyprland.tabletMode.enable;
            type = lib.types.bool;
          };

          menuButton = lib.mkOption {
            description = "Whether to add menu button for waybar.";
            default = cfg.desktop.hyprland.tabletMode.enable;
            type = lib.types.bool;
          };

          tabletSwitches = lib.mkOption {
            description = "Switches to activate tablet mode when toggled.";
            default = [];
            type = lib.types.listOf lib.types.str;
          };

          virtKeyboard = lib.mkOption {
            description = "Whether to enable dynamic virtual keyboard.";
            default = cfg.desktop.hyprland.tabletMode.enable;
            type = lib.types.bool;
          };
        };
      };

      sway = {
        enable = lib.mkOption {
          description = "Sway with full desktop session components.";
          default = osConfig.ar.desktop.sway.enable;
          type = lib.types.bool;
        };

        redShift = lib.mkOption {
          description = "Whether to redshift display colors at night.";
          default = cfg.desktop.sway.enable;
          type = lib.types.bool;
        };

        windowManagerBinds = lib.mkOption {
          description = "Default binds for window management.";
          default = {
            Down = "down";
            Left = "left";
            Right = "right";
            Up = "up";
            H = "left";
            J = "down";
            K = "up";
            L = "right";
          };
          type = lib.types.attrs;
        };
      };
    };

    services = {
      mpd = {
        enable = lib.mkEnableOption "MPD user service.";

        musicDirectory = lib.mkOption {
          description = "Name of music directory";
          default = config.xdg.userDirs.music;
          type = lib.types.str;
        };
      };

      easyeffects = {
        enable = lib.mkEnableOption "EasyEffects user service.";

        preset = lib.mkOption {
          description = "Name of preset to start with.";
          default = "";
          type = lib.types.str;
        };
      };
    };

    theme = {
      enable = lib.mkEnableOption "Gtk, Qt, and application colors.";

      darkMode = lib.mkOption {
        description = "Whether to prefer dark mode apps or not.";
        default = cfg.theme.enable;
        type = lib.types.bool;
      };

      colors = {
        text = lib.mkOption {
          description = "Text color.";
          default = "#FFFFFF";
          type = lib.types.str;
        };

        background = lib.mkOption {
          description = "Background color.";
          default = "#242424";
          type = lib.types.str;
        };

        primary = lib.mkOption {
          description = "Primary color.";
          default = "#78AEED"; #"#CA9EE6";
          type = lib.types.str;
        };

        secondary = lib.mkOption {
          description = "Secondary color.";
          default = "#CA9EE6"; #"#99D1DB";
          type = lib.types.str;
        };

        inactive = lib.mkOption {
          description = "Inactive color.";
          default = "#242424";
          type = lib.types.str;
        };

        shadow = lib.mkOption {
          description = "Drop shadow color.";
          default = "#1A1A1A";
          type = lib.types.str;
        };
      };

      gtk.hideTitleBar = lib.mkOption {
        description = "Whether to hide GTK3/4 titlebars (useful for some window managers).";
        default = false;
        type = lib.types.bool;
      };

      wallpaper = lib.mkOption {
        description = "Default wallpaper.";
        default = "${config.xdg.dataHome}/backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg";
        type = lib.types.str;
      };
    };
  };
}
