{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./homeManagerModules];
  home.username = "aly";
  home.homeDirectory = "/home/aly";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    browsh
    curl
    fractal
    gh
    git
    gnome.file-roller
    google-chrome
    keepassxc
    obsidian
    python3
    ruby
    trayscale
    wget
    zoom-us
  ];

  alyraffauf = {
    services.syncthing.enable = false;
    desktop = {
      defaultApps.enable = true;
      hyprland = {
        enable = true;
        hyprpaper.randomWallpaper = false;
      };
      sway = {
        enable = true;
        randomWallpaper = true;
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
    apps = {
      alacritty.enable = true;
      firefox.enable = true;
      bash.enable = true;
      emacs.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      chromium.enable = true;
      tauon.enable = true;
      thunderbird.enable = true;
      vsCodium.enable = true;
      webCord.enable = true;
    };
    scripts = {
      pp-adjuster.enable = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Aly Raffauf";
    userEmail = "aly@raffauflabs.com";
  };

  wayland.windowManager.sway.config.assigns = {
    "workspace 1: web" = [{app_id = "firefox";}];
    "workspace 2: code" = [{app_id = "codium-url-handler";}];
    "workspace 3: chat" = [{app_id = "org.gnome.Fractal";} {app_id = "WebCord";}];
    "workspace 4: work" = [{app_id = "google-chrome";} {app_id = "chromium-browser";}];
    "workspace 10: zoom" = [{class = "zoom";} {app_id = "Zoom";}];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    # Workspace - Browser
    workspace = 1,defaultName:web
    workspace = 2,defaultName:code

    # windowrulev2 = workspace name:browser,class:(firefox)
    windowrulev2 = workspace 1,class:(firefox)

    # Workspace - Coding
    windowrulev2 = workspace 2,class:(codium-url-handler)

    # Workspace - Zoom
    windowrulev2 = workspace name:zoom,class:(zoom)

    # Workspace - Chrome
    windowrulev2 = workspace 4,class:(google-chrome)

    # Scratchpad Magic
    windowrulev2 = workspace special:magic,class:(org.gnome.Fractal)
    windowrulev2 = workspace special:magic,class:(WebCord)
  '';
}
