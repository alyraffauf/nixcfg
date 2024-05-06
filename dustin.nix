{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./homeManagerModules];
  home.username = "dustin";
  home.homeDirectory = "/home/dustin";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    celluloid
    evince
    fractal
    gnome.eog
    gnome.file-roller
    libreoffice-fresh
    plexamp
    vlc
    xfce.xfce4-taskmanager
    zoom-us
  ];

  alyraffauf = {
    desktop = {
      defaultApps.enable = true;
      hyprland = {
        enable = true;
        hyprpaper.randomWallpaper = false;
      };
      sway = {
        enable = true;
        randomWallpaper = false;
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
          name = "NotoSansNerdFont";
          size = 11;
          package = pkgs.nerdfonts.override {fonts = ["Noto"];};
        };
        terminalFont = {
          name = "NotoSansMNerdFont";
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
      bash.enable = true;
      chromium.enable = true;
      eza.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      vsCodium.enable = true;
      webCord.enable = true;
    };
  };
}
