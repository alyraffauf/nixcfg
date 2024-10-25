{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.desktop.kde.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
