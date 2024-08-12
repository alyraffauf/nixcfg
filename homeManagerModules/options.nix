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
        default = cfg.defaultApps.fileManager == pkgs.cinnamon.nemo;
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

    theme = let
      mkFontOption = typ: nam: pkg: siz: {
        name = lib.mkOption {
          description = "Default ${typ} font name.";
          default = nam;
          type = lib.types.str;
        };

        package = lib.mkOption {
          description = "Default ${typ} font package.";
          default = pkg;
          type = lib.types.package;
        };

        size = lib.mkOption {
          description = "Default ${typ} font size.";
          default = siz;
          type = lib.types.int;
        };
      };
    in {
      enable = lib.mkEnableOption "Gtk, Qt, and application colors.";

      darkMode = lib.mkOption {
        description = "Whether to prefer dark mode apps or not.";
        default = cfg.theme.enable;
        type = lib.types.bool;
      };

      borderRadius = lib.mkOption {
        description = "Global border radius.";
        default = 10;
        type = lib.types.int;
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

      sansFont = mkFontOption "sans serif" "UbuntuSans Nerd Font" (pkgs.nerdfonts.override {fonts = ["UbuntuSans"];}) 11;
      serifFont = mkFontOption "serif" "Vegur" pkgs.vegur 11;
      monospaceFont = mkFontOption "monospace" "UbuntuSansMono Nerd Font" (pkgs.nerdfonts.override {fonts = ["UbuntuSans"];}) 11;

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
