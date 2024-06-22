{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: {
  options = {
    alyraffauf = {
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
        eza.enable = lib.mkEnableOption "Eza ls alternative.";
        fastfetch.enable = lib.mkEnableOption "Fastfetch.";
        firefox.enable = lib.mkEnableOption "Firefox web browser.";
        fuzzel.enable = lib.mkEnableOption "Fuzzel app launcher.";
        fzf.enable = lib.mkEnableOption "Fzf fuzzy file finder.";
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
        neofetch.enable = lib.mkEnableOption "Neofetch.";
        neovim.enable = lib.mkEnableOption "Neovim text editor.";
        swaylock.enable = lib.mkEnableOption "Swaylock screen locker.";
        thunar.enable = lib.mkEnableOption "Thunar file manager.";
        tmux.enable = lib.mkEnableOption "Tmux shell session manager.";
        vsCodium.enable = lib.mkEnableOption "VSCodium text editor.";
        waybar.enable = lib.mkEnableOption "Waybar wayland panel.";
        wlogout.enable = lib.mkEnableOption "Wlogout session prompt.";
      };
      defaultApps = {
        enable =
          lib.mkEnableOption "Set default apps and file associations.";
        webBrowser = {
          exe = lib.mkOption {
            description = "Default web browser executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.webBrowser.package;
            type = lib.types.str;
          };
          desktop = lib.mkOption {
            description = "Default web browser desktop file name.";
            default = "firefox.desktop";
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Default web browser package.";
            default = config.programs.firefox.package;
            type = lib.types.package;
          };
        };
        editor = {
          exe = lib.mkOption {
            description = "Default editor executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.editor.package;
            type = lib.types.str;
          };
          desktop = lib.mkOption {
            description = "Default editor desktop file name.";
            default = "codium.desktop";
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Default editor package.";
            default = config.programs.vscode.package;
            type = lib.types.package;
          };
        };
        terminalEditor = {
          exe = lib.mkOption {
            description = "Default terminal editor executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.terminalEditor.package;
            type = lib.types.str;
          };
          desktop = lib.mkOption {
            description = "Default terminal editor desktop file name.";
            default = "nvim.desktop";
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Default terminal editor package.";
            default = config.programs.neovim.package;
            type = lib.types.package;
          };
        };
        terminal = {
          exe = lib.mkOption {
            description = "Default terminal executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.terminal.package;
            type = lib.types.str;
          };
          desktop = lib.mkOption {
            description = "Default terminal desktop file name.";
            default = "alacritty.desktop";
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Default terminal package.";
            default = config.programs.alacritty.package;
            type = lib.types.package;
          };
        };
        pdfEditor = {
          exe = lib.mkOption {
            description = "Default PDF editor executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.pdfEditor.package;
            type = lib.types.str;
          };
          desktop = lib.mkOption {
            description = "Default PDF Editor desktop file name.";
            default = "org.gnome.Evince.desktop";
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Default PDF Editor package.";
            default = pkgs.evince;
            type = lib.types.package;
          };
        };
        imageViewer = {
          exe = lib.mkOption {
            description = "Default image viewer executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.imageViewer.package;
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
        videoPlayer = {
          exe = lib.mkOption {
            description = "Default video player executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.videoPlayer.package;
            type = lib.types.str;
          };
          desktop = lib.mkOption {
            description = "Default video player desktop file name.";
            default = "io.github.celluloid_player.Celluloid.desktop";
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Default video player package.";
            default = pkgs.celluloid;
            type = lib.types.package;
          };
        };
        audioPlayer = {
          exe = lib.mkOption {
            description = "Default audio player executable name.";
            default = lib.getExe config.alyraffauf.defaultApps.audioPlayer.package;
            type = lib.types.str;
          };
          desktop = lib.mkOption {
            description = "Default audio player desktop file name.";
            default = config.alyraffauf.defaultApps.videoPlayer.desktop;
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Default audio player package.";
            default = config.alyraffauf.defaultApps.videoPlayer.package;
            type = lib.types.package;
          };
        };
      };
      desktop = {
        enable = lib.mkOption {
          description = "Graphical desktop.";
          default = osConfig.alyraffauf.desktop.enable;
          type = lib.types.bool;
        };
        cinnamon.enable = lib.mkOption {
          description = "Cinnamon with sane defaults";
          default = osConfig.alyraffauf.desktop.cinnamon.enable;
          type = lib.types.bool;
        };
        gnome.enable = lib.mkOption {
          description = "GNOME with sane defaults.";
          default = osConfig.alyraffauf.desktop.gnome.enable;
          type = lib.types.bool;
        };
        hyprland = {
          enable = lib.mkOption {
            description = "Hyprland with full desktop session components.";
            default = osConfig.alyraffauf.desktop.hyprland.enable;
            type = lib.types.bool;
          };
          autoSuspend = lib.mkOption {
            description = "Whether to autosuspend on idle.";
            default = config.alyraffauf.desktop.hyprland.enable;
            type = lib.types.bool;
          };
          randomWallpaper = lib.mkOption {
            description = "Whether to enable random wallpaper script.";
            default = config.alyraffauf.desktop.hyprland.enable;
            type = lib.types.bool;
          };
          redShift = lib.mkOption {
            description = "Whether to redshift display colors at night.";
            default = config.alyraffauf.desktop.hyprland.enable;
            type = lib.types.bool;
          };
          tabletMode = {
            enable = lib.mkEnableOption "Tablet mode for hyprland.";
            autoRotate = lib.mkOption {
              description = "Whether to autorotate screen.";
              default = config.alyraffauf.desktop.hyprland.tabletMode.enable;
              type = lib.types.bool;
            };
            menuButton = lib.mkOption {
              description = "Whether to add menu button for waybar.";
              default = config.alyraffauf.desktop.hyprland.tabletMode.enable;
              type = lib.types.bool;
            };
            virtKeyboard = lib.mkOption {
              description = "Whether to enable dynamic virtual keyboard.";
              default = config.alyraffauf.desktop.hyprland.tabletMode.enable;
              type = lib.types.bool;
            };
          };
        };
        sway = {
          enable = lib.mkOption {
            description = "Sway with full desktop session components.";
            default = osConfig.alyraffauf.desktop.sway.enable;
            type = lib.types.bool;
          };
          autoSuspend = lib.mkOption {
            description = "Whether to autosuspend on idle.";
            default = config.alyraffauf.desktop.sway.enable;
            type = lib.types.bool;
          };
          randomWallpaper = lib.mkOption {
            description = "Whether to enable random wallpaper script.";
            default = config.alyraffauf.desktop.sway.enable;
            type = lib.types.bool;
          };
          redShift = lib.mkOption {
            description = "Whether to redshift display colors at night.";
            default = config.alyraffauf.desktop.sway.enable;
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
        enable = lib.mkOption {
          description = "Gtk, Qt, and application colors.";
          default = config.alyraffauf.desktop.enable;
          type = lib.types.bool;
        };
        gtk = {
          name = lib.mkOption {
            description = "GTK theme name.";
            default = "Catppuccin-Frappe-Compact-Mauve-Dark";
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
            default = config.alyraffauf.theme.enable;
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
  };
}
