{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    brightnessctl
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

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ-AA";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "breeze-gtk";
    };
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };
}
