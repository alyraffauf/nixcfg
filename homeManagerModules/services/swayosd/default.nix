{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.swayosd.enable {
    services.swayosd.enable = true;
  };
}
