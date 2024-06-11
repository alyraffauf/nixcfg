{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.neofetch.enable {
    home.packages = [pkgs.neofetch];
    xdg.configFile."neofetch/config.conf".source = ./config.conf;
  };
}
