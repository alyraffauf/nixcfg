{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.tauon.enable = lib.mkEnableOption "Enables Tauon.";};

  config = lib.mkIf config.alyraffauf.apps.tauon.enable {
    home.packages = with pkgs; [tauon];
  };
}
