{
  config,
  lib,
  ...
}: {
  options.myHome.desktop.kde.enable = lib.mkEnableOption "KDE Plasma with sane defaults.";

  config =
    lib.mkIf config.myHome.desktop.kde.enable {
    };
}
