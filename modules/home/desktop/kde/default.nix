{
  config,
  lib,
  ...
}: {
  options.myHome.desktop.kde.enable = lib.mkEnableOption "KDE desktop environment";

  config = lib.mkIf config.myHome.desktop.kde.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
      };
    };
  };
}
