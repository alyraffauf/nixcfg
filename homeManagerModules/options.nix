{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: {
  options.ar.home = {
    apps = {
      alacritty.enable = lib.mkEnableOption "Alacritty terminal.";
      bash.enable = lib.mkEnableOption "Bash defaults.";
      chromium = {
        enable = lib.mkEnableOption "Chromium-based browser with default extensions.";
        package = lib.mkOption {
          description = "Package for Chromium.";
          default = pkgs.brave;
          type = lib.types.package;
        };
      };
      emacs.enable = lib.mkEnableOption "Emacs text editor.";
      fastfetch.enable = lib.mkEnableOption "Fastfetch.";
      firefox.enable = lib.mkEnableOption "Firefox web browser.";
      fuzzel.enable = lib.mkEnableOption "Fuzzel app launcher.";
      keepassxc = {
        enable = lib.mkEnableOption "KeePassXC password manager.";
        settings = lib.mkOption {
          description = "KeePassXC settings.";
          default = {};
          type = lib.types.attrs;
        };
      };
      librewolf.enable = lib.mkEnableOption "Librewolf web browser.";
      mako.enable = lib.mkEnableOption "Mako notification daemon.";
      nemo.enable = lib.mkOption {
        description = "Cinnamon Nemo file manager.";
        default = config.ar.home.defaultApps.fileManager.package == pkgs.cinnamon.nemo;
        type = lib.types.bool;
      };
      neovim.enable = lib.mkEnableOption "Neovim text editor.";
      swaylock.enable = lib.mkEnableOption "Swaylock screen locker.";
      thunar.enable = lib.mkOption {
        description = "Thunar file manager.";
        default = config.ar.home.defaultApps.fileManager.package == pkgs.xfce.thunar;
        type = lib.types.bool;
      };
      tmux.enable = lib.mkEnableOption "Tmux shell session manager.";
      vsCodium.enable = lib.mkEnableOption "VSCodium text editor.";
      waybar.enable = lib.mkEnableOption "Waybar wayland panel.";
      wlogout.enable = lib.mkEnableOption "Wlogout session prompt.";
    };
    defaultApps = {
      enable = lib.mkEnableOption "Declaratively set default apps and file associations.";

      audioPlayer = {
        exe = lib.mkOption {
          description = "Default audio player executable.";
          default = lib.getExe config.ar.home.defaultApps.audioPlayer.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default audio player desktop file.";
          default = config.ar.home.defaultApps.videoPlayer.desktop;
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default audio player package.";
          default = config.ar.home.defaultApps.videoPlayer.package;
          type = lib.types.package;
        };
      };
      editor = {
        exe = lib.mkOption {
          description = "Default editor executable.";
          default = lib.getExe config.ar.home.defaultApps.editor.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default editor desktop file.";
          default = "codium.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default editor package.";
          default = config.programs.vscode.package;
          type = lib.types.package;
        };
      };
      fileManager = {
        exe = lib.mkOption {
          description = "Default file manager executable.";
          default = lib.getExe config.ar.home.defaultApps.fileManager.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default file manager desktop file.";
          default = "nemo.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default file manager package.";
          default = pkgs.cinnamon.nemo;
          type = lib.types.package;
        };
      };
      imageViewer = {
        exe = lib.mkOption {
          description = "Default image viewer executable.";
          default = lib.getExe config.ar.home.defaultApps.imageViewer.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default image viewer desktop file name.";
          default = "org.gnome.eog.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default image viewer package.";
          default = pkgs.gnome.eog;
          type = lib.types.package;
        };
      };
      pdfViewer = {
        exe = lib.mkOption {
          description = "Default PDF viewer executable.";
          default = lib.getExe config.ar.home.defaultApps.pdfEditor.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default PDF viewer desktop file.";
          default = "org.gnome.Evince.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default PDF viewer package.";
          default = pkgs.evince;
          type = lib.types.package;
        };
      };
      terminal = {
        exe = lib.mkOption {
          description = "Default terminal executable.";
          default = lib.getExe config.ar.home.defaultApps.terminal.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default terminal desktop file.";
          default = "alacritty.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default terminal package.";
          default = config.programs.alacritty.package;
          type = lib.types.package;
        };
      };
      terminalEditor = {
        exe = lib.mkOption {
          description = "Default terminal editor executable.";
          default = lib.getExe config.ar.home.defaultApps.terminalEditor.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default terminal editor desktop file.";
          default = "nvim.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default terminal editor package.";
          default = config.programs.nixvim.package;
          type = lib.types.package;
        };
      };
      videoPlayer = {
        exe = lib.mkOption {
          description = "Default video player executable.";
          default = lib.getExe config.ar.home.defaultApps.videoPlayer.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default video player desktop file.";
          default = "io.github.celluloid_player.Celluloid.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default video player package.";
          default = pkgs.celluloid;
          type = lib.types.package;
        };
      };
      webBrowser = {
        exe = lib.mkOption {
          description = "Default web browser executable.";
          default = lib.getExe config.ar.home.defaultApps.webBrowser.package;
          type = lib.types.str;
        };
        desktop = lib.mkOption {
          description = "Default web browser desktop file.";
          default = "firefox.desktop";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Default web browser package.";
          default = config.programs.firefox.package;
          type = lib.types.package;
        };
      };
    };
    desktop = {
      cinnamon.enable = lib.mkOption {
        description = "Cinnamon with sane defaults";
        default = osConfig.ar.desktop.cinnamon.enable;
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
        autoSuspend = lib.mkOption {
          description = "Whether to autosuspend on idle.";
          default = config.ar.home.desktop.hyprland.enable;
          type = lib.types.bool;
        };
        randomWallpaper = lib.mkOption {
          description = "Whether to enable random wallpaper script.";
          default = config.ar.home.desktop.hyprland.enable;
          type = lib.types.bool;
        };
        redShift = lib.mkOption {
          description = "Whether to redshift display colors at night.";
          default = config.ar.home.desktop.hyprland.enable;
          type = lib.types.bool;
        };
        tabletMode = {
          enable = lib.mkEnableOption "Tablet mode for hyprland.";
          autoRotate = lib.mkOption {
            description = "Whether to autorotate screen.";
            default = config.ar.home.desktop.hyprland.tabletMode.enable;
            type = lib.types.bool;
          };
          menuButton = lib.mkOption {
            description = "Whether to add menu button for waybar.";
            default = config.ar.home.desktop.hyprland.tabletMode.enable;
            type = lib.types.bool;
          };
          virtKeyboard = lib.mkOption {
            description = "Whether to enable dynamic virtual keyboard.";
            default = config.ar.home.desktop.hyprland.tabletMode.enable;
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
        autoSuspend = lib.mkOption {
          description = "Whether to autosuspend on idle.";
          default = config.ar.home.desktop.sway.enable;
          type = lib.types.bool;
        };
        randomWallpaper = lib.mkOption {
          description = "Whether to enable random wallpaper script.";
          default = config.ar.home.desktop.sway.enable;
          type = lib.types.bool;
        };
        redShift = lib.mkOption {
          description = "Whether to redshift display colors at night.";
          default = config.ar.home.desktop.sway.enable;
          type = lib.types.bool;
        };
      };
      startupApps = lib.mkOption {
        description = "Apps to launch at startup";
        default = [];
        type = lib.types.listOf (lib.types.str);
      };
    };
    scripts = {
      pp-adjuster.enable = lib.mkEnableOption "pp-adjuster script.";
    };
    services = {
      mpd = {
        enable =
          lib.mkEnableOption "MPD user service.";
        musicDirectory = lib.mkOption {
          description = "Name of music directory";
          default = config.xdg.userDirs.music;
          type = lib.types.str;
        };
      };
      easyeffects = {
        enable =
          lib.mkEnableOption "EasyEffects user service.";
        preset = lib.mkOption {
          description = "Name of preset to start with.";
          default = "";
          type = lib.types.str;
        };
      };
    };

    theme = {
      enable = lib.mkEnableOption "Gtk, Qt, and application colors.";

      gtk = {
        name = lib.mkOption {
          description = "GTK theme name.";
          default = "catppuccin-frappe-mauve-compact+normal";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "GTK theme package.";
          default = pkgs.catppuccin-gtk;
          type = lib.types.package;
        };
        hideTitleBar = lib.mkOption {
          description = "Whether to hide GTK3/4 titlebars (useful for some window managers).";
          default = false;
          type = lib.types.bool;
        };
      };
      qt = {
        name = lib.mkOption {
          description = "Qt Kvantum theme name.";
          default = "Catppuccin-Frappe-Mauve";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Qt Kvantum theme package.";
          default = pkgs.catppuccin-kvantum;
          type = lib.types.package;
        };
      };
      iconTheme = {
        name = lib.mkOption {
          description = "Icon theme name.";
          default = "Papirus-Dark";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Icon theme package.";
          default = pkgs.catppuccin-papirus-folders;
          type = lib.types.package;
        };
      };
      cursorTheme = {
        name = lib.mkOption {
          description = "Cursor theme name.";
          default = "Catppuccin-Frappe-Dark-Cursors";
          type = lib.types.str;
        };
        size = lib.mkOption {
          description = "Cursor size.";
          default = 24;
          type = lib.types.int;
        };
        package = lib.mkOption {
          description = "Cursor theme package.";
          default = pkgs.catppuccin-cursors.frappeDark;
          type = lib.types.package;
        };
      };
      font = {
        name = lib.mkOption {
          description = "Font name.";
          default = "NotoSans Nerd Font";
          type = lib.types.str;
        };
        size = lib.mkOption {
          description = "Font size.";
          default = 11;
          type = lib.types.int;
        };
        package = lib.mkOption {
          description = "Font package.";
          default = pkgs.nerdfonts;
          type = lib.types.package;
        };
      };
      terminalFont = {
        name = lib.mkOption {
          description = "Font name.";
          default = "NotoSansM Nerd Font";
          type = lib.types.str;
        };
        size = lib.mkOption {
          description = "Font size.";
          default = 11;
          type = lib.types.int;
        };
        package = lib.mkOption {
          description = "Font package.";
          default = pkgs.nerdfonts;
          type = lib.types.package;
        };
      };
      colors = {
        preferDark = lib.mkOption {
          description = "Whether to prefer dark mode apps or not.";
          default = config.ar.home.theme.enable;
          type = lib.types.bool;
        };
        text = lib.mkOption {
          description = "Text color.";
          default = "#FAFAFA";
          type = lib.types.str;
        };
        background = lib.mkOption {
          description = "Background color.";
          default = "#232634";
          type = lib.types.str;
        };
        primary = lib.mkOption {
          description = "Primary color.";
          default = "#CA9EE6";
          type = lib.types.str;
        };
        secondary = lib.mkOption {
          description = "Secondary color.";
          default = "#99D1DB";
          type = lib.types.str;
        };
        inactive = lib.mkOption {
          description = "Inactive color.";
          default = "#626880";
          type = lib.types.str;
        };
        shadow = lib.mkOption {
          description = "Drop shadow color.";
          default = "#1A1A1A";
          type = lib.types.str;
        };
      };
      wallpaper = lib.mkOption {
        description = "Default wallpaper.";
        default = "${config.xdg.dataHome}/backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg";
        type = lib.types.str;
      };
    };
  };
}
