{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.firefox.enable {
    programs.firefox = {enable = true;};
  };
}
