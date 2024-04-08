{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {guiApps.webCord.enable = lib.mkEnableOption "Enables WebCord.";};

  config = lib.mkIf config.guiApps.webCord.enable {
    home.packages = with pkgs; [webcord];
  };
}
