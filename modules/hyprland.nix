{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ./desktop.nix
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.hyprland.enable = true;
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
