{ config, pkgs, ... }:

{
  imports =
    [ # Include X settings.
      ./desktop.nix
    ];

    services.xserver.displayManager = {
        sessionPackages = [ pkgs.sway ];
    };

    programs.light.enable = true; # Brightness and volume control.
    programs.dconf.enable = true;
    services.xserver.libinput.enable = true;
    services.gnome.gnome-keyring.enable = true;
    xdg.portal.wlr.enable = true;
    xdg.portal.config.common.default = "*";
}