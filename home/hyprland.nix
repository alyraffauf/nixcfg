{ config, pkgs, ... }:

{
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      bemenu
      brightnessctl
      hyprcursor
      hypridle
      hyprlock
      hyprpaper
      hyprshade
      hyprshot
      mako
      overskride
      udiskie
      xfce.thunar
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./dotfiles/hyprland.conf;
    };

    xdg.configFile."hypr/hypridle.conf".source = ./dotfiles/hypridle.conf;
    programs.waybar.enable = true;
    programs.waybar.settings = {
        mainBar = {
            layer = "top";
            position = "top";
            height = 36;
            output = [
                "eDP-1"
                "HDMI-A-1"
            ];
            modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
            modules-center = [ "hyprland/window" ];
            modules-right = [ "tray" "battery" "clock"];

            "hyprland/workspaces" = {
                all-outputs = true;
            };
            "clock" = {
                "interval" = 60;
                "format" = "{:%I:%M}";
            };
        };
    };
}
