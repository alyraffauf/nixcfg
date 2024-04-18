{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.google-chrome.enable = lib.mkEnableOption "Enable Google Chrome.";
  };

  config = lib.mkIf config.alyraffauf.apps.google-chrome.enable {
    home.packages = with pkgs; [google-chrome];
  };
}
