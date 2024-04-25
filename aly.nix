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
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    browsh
    curl
    fractal
    gh
    git
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })
    obsidian
    python3
    ruby
    wget
    zoom-us
  ];

  alyraffauf = {
    services.syncthing.enable = false;
    desktop = {
      hyprland = {
        enable = true;
        hyprpaper.randomWallpaper = true;
      };
      sway = {
        enable = true;
        randomWallpaper = true;
      };
    };
    apps = {
      alacritty.enable = true;
      firefox.enable = true;
      bash.enable = true;
      emacs.enable = true;
      eza.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      chromium.enable = false;
      tauon.enable = true;
      thunderbird.enable = true;
      vsCodium.enable = true;
      webCord.enable = true;
    };
  };
  wayland.windowManager.sway.config.assigns = {
    "workspace 1: web" = [{app_id = "firefox";}];
    "workspace 2: code" = [{app_id = "codium-url-handler";}];
    "workspace 3: chat" = [{app_id = "org.gnome.Fractal";} {app_id = "WebCord";}];
  };
  wayland.windowManager.hyprland.extraConfig = ''
    # Workspace - Browser
    # workspace = name:browser,1, rounding:false, decorate:false, gapsin:0, gapsout:0, border:false
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
