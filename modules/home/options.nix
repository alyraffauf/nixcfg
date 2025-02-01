{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome = {
    apps = {
      chromium = {
        enable = lib.mkEnableOption "Chromium-based browser with default extensions.";
        package = lib.mkPackageOption pkgs "brave" {};
      };

      fastfetch.enable = lib.mkEnableOption "Fastfetch.";
      firefox.enable = lib.mkEnableOption "Firefox web browser.";
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

      nemo.enable = lib.mkOption {
        description = "Cinnamon Nemo file manager.";
        default = cfg.defaultApps.fileManager == pkgs.nemo;
        type = lib.types.bool;
      };

      rofi.enable = lib.mkEnableOption "Rofi launcher.";
      shell.enable = lib.mkEnableOption "Shell with defaults.";
      vsCodium.enable = lib.mkEnableOption "VSCodium text editor.";
      wezterm.enable = lib.mkEnableOption "Wezterm terminal.";
      yazi.enable = lib.mkEnableOption "Yazi terminal file manager.";
      zed.enable = lib.mkEnableOption "Zed text editor.";
    };

    defaultApps = {
      enable = lib.mkEnableOption "Declaratively set default apps and file associations.";
      forceMimeAssociations = lib.mkEnableOption "Force mime associations for defaultApps.";

      audioPlayer = lib.mkPackageOption pkgs "audio player" {default = ["celluloid"];};
      editor = lib.mkPackageOption pkgs "text editor" {default = ["vscodium"];};
      fileManager = lib.mkPackageOption pkgs "file manager" {default = ["nemo"];};
      imageViewer = lib.mkPackageOption pkgs "image viewer" {default = ["eog"];};
      pdfViewer = lib.mkPackageOption pkgs "pdf viewer" {default = ["evince"];};
      terminal = lib.mkPackageOption pkgs "terminal emulator" {default = ["wezterm"];};
      terminalEditor = lib.mkPackageOption pkgs "terminal text editor" {default = ["vim"];};
      videoPlayer = lib.mkPackageOption pkgs "video player" {default = ["celluloid"];};

      webBrowser = lib.mkOption {
        description = "web browser";
        default = config.programs.firefox.finalPackage;
        type = lib.types.package;
      };
    };

    desktop = {
      autoSuspend = lib.mkOption {
        description = "Whether to autosuspend on idle.";
        default = cfg.desktop.hyprland.enable or false;
        type = lib.types.bool;
      };

      gnome.enable = lib.mkEnableOption "GNOME with sane defaults.";

      hyprland = {
        enable = lib.mkEnableOption "Hyprland with full desktop session components.";

        laptopMonitor = lib.mkOption {
          description = "Internal laptop monitor.";
          default = null;
          type = lib.types.nullOr lib.types.str;
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

      kde.enable = lib.mkEnableOption "KDE Plasma with sane defaults.";

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
      hypridle.enable = lib.mkEnableOption "Hypridle idle daemon.";
      mako.enable = lib.mkEnableOption "Mako notification daemon.";

      pipewire-inhibit.enable = lib.mkEnableOption "Inhibit idle when audio is playing with Pipewire.";
      randomWallpaper.enable = lib.mkEnableOption "Lightweight swaybg-based random wallpaper daemon.";
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
