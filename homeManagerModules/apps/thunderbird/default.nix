{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.thunderbird.enable = lib.mkEnableOption "Enable Thunderbird.";};

  config = lib.mkIf config.alyraffauf.apps.thunderbird.enable {
    home.packages = [pkgs.thunderbird];
  };
}
