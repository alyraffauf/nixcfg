{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.ar.home.desktop.hyprland.enable || config.ar.home.desktop.sway.enable) {
    ar.home.apps = {
      fuzzel.enable = lib.mkDefault true;
      mako.enable = lib.mkDefault true;
      swaylock.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      wlogout.enable = lib.mkDefault true;
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "";
        "org/gnome/nm-applet".disable-connected-notifications = true;
      };
    };

    home.packages = with pkgs; [
      gnome.file-roller
      networkmanagerapplet
      swayosd
    ];

    xdg.portal = {
      enable = true;
      configPackages =
        lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
      extraPortals =
        [pkgs.xdg-desktop-portal-gtk]
        ++ lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
