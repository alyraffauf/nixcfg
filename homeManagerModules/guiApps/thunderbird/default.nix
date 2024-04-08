{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {guiApps.thunderbird.enable = lib.mkEnableOption "Enable Thunderbird.";};

  config = lib.mkIf config.guiApps.thunderbird.enable {
    home.packages = [pkgs.thunderbird];
  };
}
