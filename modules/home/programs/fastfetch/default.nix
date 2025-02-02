{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.fastfetch.enable = lib.mkEnableOption "fastfetch system information";

  config = lib.mkIf config.myHome.programs.fastfetch.enable {
    home.packages = [pkgs.fastfetch];
    xdg.configFile."fastfetch/config.jsonc".text = lib.generators.toJSON {} (import ./config.nix);
  };
}
