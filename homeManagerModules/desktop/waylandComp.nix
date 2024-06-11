{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.waylandComp {
    home.packages = with pkgs; [
      swayosd
      networkmanagerapplet
    ];
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
  };
}
