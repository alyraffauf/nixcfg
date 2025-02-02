{
  config,
  lib,
  ...
}: {
  options.myHome.desktop.kde.enable = lib.mkEnableOption "KDE Plasma with sane defaults.";

  config = lib.mkIf config.myHome.desktop.kde.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
        "org/gnome/nm-applet".disable-connected-notifications = true;
        "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
        "org/gtk/settings/file-chooser".sort-directories-first = true;
      };
    };
  };
}
