{
  lib,
  pkgs,
  ...
}: {
  config = {
    home.packages = [pkgs.fastfetch];
    xdg.configFile."fastfetch/config.jsonc".text = lib.generators.toJSON {} (import ./config.nix);
  };
}
