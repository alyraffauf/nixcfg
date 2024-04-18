{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.firefox.enable = lib.mkEnableOption "Enables Firefox.";};

  config = lib.mkIf config.alyraffauf.apps.firefox.enable {
    programs.firefox = {enable = true;};
  };
}
