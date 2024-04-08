{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {guiApps.firefox.enable = lib.mkEnableOption "Enables Firefox.";};

  config = lib.mkIf config.guiApps.firefox.enable {
    programs.firefox = {enable = true;};
  };
}
