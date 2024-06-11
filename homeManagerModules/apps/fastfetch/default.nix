{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.fastfetch.enable {
    home.packages = [pkgs.fastfetch];
    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
