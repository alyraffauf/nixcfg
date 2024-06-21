{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  home = {
    homeDirectory = "/home/aly";
    file.".cache/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
      General.LastActiveDatabase = "${config.home.homeDirectory}/sync/Passwords.kdbx";
    };
    packages = with pkgs; [
      browsh
      curl
      fractal
      gh
      git
      google-chrome
      obsidian
      plexamp
      python3
      ruby
      tauon
      trayscale
      webcord
      wget
    ];
    stateVersion = "24.05";
    username = "aly";
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Aly Raffauf";
      userEmail = "aly@raffauflabs.com";
    };
  };

  wayland.windowManager = {
    sway.config = {
      assigns = {
        "workspace 1: web" = [{app_id = "firefox";} {app_id = "brave-browser";}];
        "workspace 2: code" = [{app_id = "codium-url-handler";}];
        "workspace 3: chat" = [{app_id = "org.gnome.Fractal";} {app_id = "WebCord";}];
        "workspace 4: work" = [{app_id = "google-chrome";} {app_id = "chromium-browser";}];
        "workspace 10: zoom" = [{class = "zoom";} {app_id = "Zoom";}];
      };

      startup = [
        {command = ''${lib.getExe' pkgs.keepassxc "keepassxc"}'';}
      ];
    };

    hyprland.extraConfig = ''
      # Workspace - Browser
      workspace = 1, defaultName:web, on-created-empty:${config.alyraffauf.defaultApps.webBrowser.exe}
      windowrulev2 = workspace 1,class:(firefox)
      windowrulev2 = workspace 1,class:(brave-browser)

      # Workspace - Coding
      workspace = 2, defaultName:code, on-created-empty:${config.alyraffauf.defaultApps.editor.exe}
      windowrulev2 = workspace 2,class:(codium-url-handler)

      # Workspace - Chrome
      windowrulev2 = workspace 3,class:(google-chrome)

      # Scratchpad Chat
      # bind = SUPER, S, togglespecialworkspace, magic
      # bind = SUPER SHIFT, W, movetoworkspace, special:magic
      workspace = special:magic, on-created-empty:${lib.getExe pkgs.fractal}
      windowrulev2 = workspace special:magic,class:(org.gnome.Fractal)
      windowrulev2 = workspace special:magic,class:(WebCord)

      # Scratchpad Notes
      bind = SUPER, N, togglespecialworkspace, notes
      bind = SUPER SHIFT, N, movetoworkspace, special:notes
      workspace = special:notes, on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}
      # windowrulev2 = workspace special:notes,class:(obsidian)

      # # Scratchpad Music
      # bind = SUPER, P, togglespecialworkspace, music
      # bind = SUPER SHIFT, P, movetoworkspace, special:music
      # workspace = special:music, on-created-empty:${lib.getExe' pkgs.plexamp "plexamp"}
      # windowrulev2 = workspace special:music,class:(Plexamp)
    '';
  };

  alyraffauf = {
    apps = {
      alacritty.enable = true;
      bash.enable = true;
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      emacs.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      keepassxc = {
        enable = true;
        settings = {
          Browser = {
            AlwaysAllowAccess = true;
            Enabled = true;
            SearchInAllDatabases = true;
          };

          General = {
            ConfigVersion = 2;
            HideWindowOnCopy = true;
            MinimizeAfterUnlock = false;
            MinimizeOnOpenUrl = true;
          };

          GUI = {
            ApplicationTheme = "classic";
            ColorPasswords = false;
            CompactMode = true;
            MinimizeOnClose = true;
            MinimizeOnStartup = true;
            MinimizeToTray = true;
            ShowTrayIcon = true;
            TrayIconAppearance = "colorful";
          };

          Security = {
            ClearClipboardTimeout = 15;
            EnableCopyOnDoubleClick = true;
            IconDownloadFallback = true;
            LockDatabaseScreenLock = false;
          };

          SSHAgent = {
            Enabled = true;
          };
        };
      };
      neofetch.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      vsCodium.enable = true;
    };

    defaultApps = {
      enable = true;
      webBrowser = {
        package = config.programs.chromium.package;
        desktop = "brave-browser.desktop";
      };
    };

    desktop = {
      startupApps = [(lib.getExe' pkgs.keepassxc "keepassxc")];
    };

    scripts = {
      pp-adjuster.enable = true;
    };

    theme = {
      enable = true;

      gtk = {
        name = "Catppuccin-Frappe-Compact-Mauve-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["mauve"];
          size = "compact";
          variant = "frappe";
          tweaks = ["normal"];
        };
      };

      qt = {
        name = "Catppuccin-Frappe-Mauve";
        package = pkgs.catppuccin-kvantum.override {
          accent = "Mauve";
          variant = "Frappe";
        };
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "frappe";
          accent = "mauve";
        };
      };

      cursorTheme = {
        name = "Catppuccin-Frappe-Dark-Cursors";
        size = 24;
        package = pkgs.catppuccin-cursors.frappeDark;
      };

      font = {
        name = "NotoSans Nerd Font";
        size = 11;
        package = pkgs.nerdfonts.override {fonts = ["Noto"];};
      };

      terminalFont = {
        name = "NotoSansM Nerd Font";
        size = 11;
        package = pkgs.nerdfonts.override {fonts = ["Noto"];};
      };

      colors = {
        text = "#FAFAFA";
        background = "#232634";
        primary = "#CA9EE6";
        secondary = "#99D1DB";
        inactive = "#626880";
        shadow = "#1A1A1A";
      };

      wallpaper = "${config.xdg.dataHome}/backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg";
    };
  };
}
