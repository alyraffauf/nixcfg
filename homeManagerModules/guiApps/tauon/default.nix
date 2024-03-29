{ pkgs, lib, config, ... }: {

  options = { guiApps.tauon.enable = lib.mkEnableOption "Enables Tauon."; };

  config = lib.mkIf config.guiApps.tauon.enable {
    home.packages = with pkgs; [ tauon ];
  };
}
