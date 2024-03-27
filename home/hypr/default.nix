{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    brightnessctl
    evince
    hyprcursor
    hypridle
    hyprland-protocols
    hyprlock
    hyprnome
    hyprpaper
    hyprshade
    hyprshot
    playerctl
    pyprland
    xdg-desktop-portal-hyprland
    xfce.exo
    xfce.ristretto
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
    xfce.tumbler
    xfce.xfce4-settings
    xfce.xfce4-taskmanager
    xfce.xfconf
  ];

  services.gpg-agent.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;

  xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;

  xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  xdg.configFile."hypr/wallpapers/tokyoGreen.jpg".source =
    ./wallpapers/tokyoGreen.jpg;
  xdg.configFile."hypr/wallpapers/greenCity.jpg".source =
    ./wallpapers/greenCity.jpg;
  xdg.configFile."hypr/wallpapers/jr-korpa-9XngoIpxcEo-unsplash.jpg".source =
    ./wallpapers/jr-korpa-9XngoIpxcEo-unsplash.jpg;

  xdg.configFile."hypr/shaders/blue-light-filter.glsl".source =
    ./blue-light-filter.glsl;
  xdg.configFile."hypr/hyprshade.toml".source = ./hyprshade.toml;

  xdg.configFile."hypr/pyprland.toml".source = ./pyprland.toml;

  xdg.configFile."xfce4/helpers.rc".source = ../xfce/helpers.rc;

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.catppuccin-cursors.frappeDark;
    name = "Catppuccin-Frappe-Dark-Cursors";
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "Catppuccin-Frappe-Compact-Mauve-Dark";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        variant = "frappe";
        tweaks = [ "normal" ];
      };
      name = "Catppuccin-Frappe-Compact-Mauve-Dark";
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "mauve";
      };
      name = "Papirus-Dark";
    };
    font = {
      name = "NotoSans Nerd Font Regular";
      size = 11;
    };
  };
}
