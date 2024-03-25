{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    brightnessctl
    gnome.eog
    hyprcursor
    hypridle
    hyprlock
    hyprpaper
    hyprshade
    hyprshot
    playerctl
    udiskie
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
  
  xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;

  xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  xdg.configFile."hypr/tokyoGreen.jpg".source = ./tokyoGreen.jpg;
  xdg.configFile."hypr/greenCity.jpg".source = ./greenCity.jpg;

  xdg.configFile."hypr/shaders/blue-light-filter.glsl".source = ./blue-light-filter.glsl;
  xdg.configFile."hypr/hyprshade.toml".source = ./hyprshade.toml;
  
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ-AA";
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "Catppuccin-Latte-Compact-Green-Light";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = [ "green" ];
        size = "compact";
        variant = "latte";
        tweaks = [ "normal" ];
      };
      name = "Catppuccin-Latte-Compact-Green-Light";
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "latte";
        accent = "green";
      };
      name = "Papirus-Light";
    };
    font = {
      name = "Noto Sans Nerd Font Regular";
      size = 11;
    };
  };
}
