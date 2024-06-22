{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.alyraffauf.desktop.hyprland.enable || config.alyraffauf.desktop.sway.enable) {
    alyraffauf = {
      apps = {
        fuzzel.enable = lib.mkDefault true;
        mako.enable = lib.mkDefault true;
        nemo.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
        wlogout.enable = lib.mkDefault true;
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "";
        };
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
