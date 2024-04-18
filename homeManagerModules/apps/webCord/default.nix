{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.webCord.enable = lib.mkEnableOption "Enables WebCord.";};

  config = lib.mkIf config.alyraffauf.apps.webCord.enable {
    home.packages = with pkgs; [webcord];
  };
}
