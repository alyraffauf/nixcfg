{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {guiApps.thunderbird.enable = lib.mkEnableOption "Enable Thunderbird.";};

  config = lib.mkIf config.guiApps.thunderbird.enable {
    programs.thunderbird = {enable = true;};
  };
}
