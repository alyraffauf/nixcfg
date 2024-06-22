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
    file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
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
      keepassxc.enable = true;
      neofetch.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      vsCodium.enable = true;
    };

    defaultApps = {
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
      wallpaper = "${config.xdg.dataHome}/backgrounds/wallhaven-3led2d.jpg";
    };
  };
}
