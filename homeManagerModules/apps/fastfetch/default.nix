{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.fastfetch.enable = lib.mkEnableOption "Enable fastfetch.";
  };

  config = lib.mkIf config.alyraffauf.apps.fastfetch.enable {
    home.packages = [pkgs.fastfetch];
    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
