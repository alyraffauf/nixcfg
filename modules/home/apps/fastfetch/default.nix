{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.myHome.apps.fastfetch.enable {
    home.packages = [pkgs.fastfetch];
    xdg.configFile."fastfetch/config.jsonc".text = lib.generators.toJSON {} (import ./config.nix);
  };
}
