{
  config,
  lib,
  ...
}: {
  config =
    lib.mkIf config.myHome.desktop.kde.enable {
    };
}
