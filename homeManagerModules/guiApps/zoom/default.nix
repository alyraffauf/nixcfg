{ pkgs, lib, config, ... }: {

  options = { guiApps.zoom.enable = lib.mkEnableOption "Enables Zoom."; };

  config = lib.mkIf config.guiApps.zoom.enable {
    home.packages = with pkgs; [ zoom-us ];
  };
}
