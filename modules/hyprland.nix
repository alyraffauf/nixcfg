{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ./desktop.nix
    ];

    programs.hyprland.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      bemenu
      brightnessctl
      hyprcursor
      hypridle
      hyprlock
      hyprpaper
      hyprshade
      hyprshot
      mako
      nheko
      overskride
      udiskie
      waybar
      xfce.thunar
    ];
}
