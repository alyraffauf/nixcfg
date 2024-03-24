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

    services.mako = {
      enable = true;
      font = "DroidSansM Nerd Font Mono 11";
      backgroundColor = "#00000080";
      textColor = "#FFFFFF";
      borderRadius = 10;
      defaultTimeout = 10000;
      padding = "15";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };

    xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
}
