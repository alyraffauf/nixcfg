{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.obsidian.enable = lib.mkEnableOption "Enables Obsidian.";
  };

  config = lib.mkIf config.alyraffauf.apps.obsidian.enable {
    home.packages = with pkgs; [obsidian];
  };
}
