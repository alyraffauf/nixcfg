{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  home = {
    username = "dustin";
    homeDirectory = "/home/dustin";
    stateVersion = "24.05";
    packages = with pkgs; [
      fractal
      libreoffice-fresh
      plexamp
      vlc
      webcord
      xfce.xfce4-taskmanager
      zoom-us
    ];
  };

  programs.home-manager.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/epub+zip" = "com.calibre_ebook.calibre.desktop;org.gnome.Evince.desktop;com.calibre_ebook.calibre.ebook-viewer.desktop;";
    };
  };

  alyraffauf = {
    apps = {
      alacritty.enable = true;
      bash.enable = true;
      chromium.enable = true;
      eza.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      vsCodium.enable = true;
    };
    defaultApps.enable = true;
    desktop = {
      hyprland = {
        randomWallpaper = false;
      };
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
