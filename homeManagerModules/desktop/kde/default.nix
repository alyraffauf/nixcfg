{
  config,
  lib,
  ...
}: {
  config =
    lib.mkIf config.ar.home.desktop.kde.enable {
    };
}
