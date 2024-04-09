{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    guiApps.google-chrome.enable = lib.mkEnableOption "Enable Google Chrome.";
  };

  config = lib.mkIf config.guiApps.google-chrome.enable {
    home.packages = with pkgs; [google-chrome];
  };
}
