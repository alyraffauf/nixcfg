{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.neofetch.enable = lib.mkEnableOption "Enable neofetch.";
  };

  config = lib.mkIf config.alyraffauf.apps.neofetch.enable {
    home.packages = [pkgs.neofetch];
    xdg.configFile."neofetch/config.conf".source = ./config.conf;
  };
}
