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
        package = lib.mkPackageOption pkgs "keepassxc" {};

        settings = lib.mkOption {
          description = "KeePassXC settings.";
          default = {};
          type = lib.types.attrs;
        };
      };

      kitty.enable = lib.mkEnableOption "Kitty terminal.";
      librewolf.enable = lib.mkEnableOption "Librewolf web browser.";

      nemo.enable = lib.mkOption {
        description = "Cinnamon Nemo file manager.";
        default = cfg.defaultApps.fileManager == pkgs.nemo;
        type = lib.types.bool;
      };

      rofi.enable = lib.mkEnableOption "Rofi launcher.";
      shell.enable = lib.mkEnableOption "Shell with defaults.";
      swaylock.enable = lib.mkEnableOption "Swaylock screen locker.";

      thunar.enable = lib.mkOption {
        description = "Thunar file manager.";
        default = cfg.defaultApps.fileManager == pkgs.xfce.thunar;
        type = lib.types.bool;
      };

      tmux.enable = lib.mkEnableOption "Tmux shell session manager.";
      vsCodium.enable = lib.mkEnableOption "VSCodium text editor.";
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
      fileManager = lib.mkPackageOption pkgs "file manager" {default = ["nemo"];};
      imageViewer = lib.mkPackageOption pkgs "image viewer" {default = ["eog"];};
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

      gnome.enable = lib.mkOption {
        description = "GNOME with sane defaults.";
        default = osConfig.ar.desktop.gnome.enable;
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

        tabletMode = {
          enable = lib.mkEnableOption "Tablet mode for hyprland.";

          switches = lib.mkOption {
            description = "Switches to activate tablet mode when toggled.";
            default = [];
            type = lib.types.listOf lib.types.str;
          };
        };
      };

      sway = {
        enable = lib.mkOption {
          description = "Sway with full desktop session components.";
          default = osConfig.ar.desktop.sway.enable;
          type = lib.types.bool;
        };
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

    laptopMode = lib.mkOption {
      description = "Enable laptop configuration.";
      default = osConfig.ar.laptopMode;
      type = lib.types.bool;
    };

    services = {
      easyeffects = {
        enable = lib.mkEnableOption "EasyEffects user service.";

        preset = lib.mkOption {
          description = "Name of preset to start with.";
          default = "";
          type = lib.types.str;
        };
      };

      gammastep.enable = lib.mkEnableOption "Gammastep redshift daemon.";
      mako.enable = lib.mkEnableOption "Mako notification daemon.";

      mpd = {
        enable = lib.mkEnableOption "MPD user service.";

        musicDirectory = lib.mkOption {
          description = "Name of music directory";
          default = config.xdg.userDirs.music;
          type = lib.types.str;
        };
      };

      pipewire-inhibit.enable = lib.mkEnableOption "Inhibit idle when audio is playing with Pipewire.";
      randomWallpaper.enable = lib.mkEnableOption "Lightweight swaybg-based random wallpaper daemon.";
      swayidle.enable = lib.mkEnableOption "Swayidle idle daemon.";
      swayosd.enable = lib.mkEnableOption "OSD for brightness and volume keys.";
      waybar.enable = lib.mkEnableOption "Waybar wayland panel.";
    };

    theme = {
      enable = lib.mkEnableOption "Gtk, Qt, and application colors.";

      borders = {
        radius = lib.mkOption {
          description = "Global border radius.";
          default = 10;
          type = lib.types.int;
        };
      };

      gtk.hideTitleBar = lib.mkOption {
        description = "Whether to hide GTK3/4 titlebars (useful for some window managers).";
        default = false;
        type = lib.types.bool;
      };
    };
  };
}
