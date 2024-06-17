{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.waylandComp {
    alyraffauf = {
      apps = {
        fuzzel.enable = lib.mkDefault true;
        mako.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
        thunar.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
        wlogout.enable = lib.mkDefault true;
      };
      theme.enable = lib.mkDefault true;
      defaultApps.enable = lib.mkDefault true;
    };

    dconf = {
      enable = true;
      settings = {
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
        lib.optionals (config.alyraffauf.desktop.hyprland.enable) [pkgs.xdg-desktop-portal-hyprland];
      extraPortals =
        lib.optionals (config.alyraffauf.desktop.hyprland.enable) [pkgs.xdg-desktop-portal-hyprland];
    };
  };
}
