{ pkgs, lib, config, ... }: {

  options = {
    guiApps.obsidian.enable = lib.mkEnableOption "Enables Obsidian.";
  };

  config = lib.mkIf config.guiApps.obsidian.enable {
    home.packages = with pkgs; [ obsidian ];
  };
}
