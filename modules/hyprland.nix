{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ./desktop.nix
    ];

    programs.hyprland.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
