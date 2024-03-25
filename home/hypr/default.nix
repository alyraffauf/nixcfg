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

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ-AA";
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style.package = pkgs.kdePackages.breeze;
    style.name = "Breeze";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze-dark";
    };
    font = {
      name = "Noto Sans Nerd Font Regular";
      size = 11;
    };
  };
}
