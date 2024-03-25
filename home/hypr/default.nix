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
    platformTheme = "qtct";
    # style.package = pkgs.kdePackages.breeze;
    style.name = "Adwaita";
  };

  gtk = {
    enable = true;
    theme = {
      # package = pkgs.kdePackages.breeze-gtk;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze";
    };
    font = {
      name = "Noto Sans Nerd Font Regular";
      size = 11;
    };
  };
}
