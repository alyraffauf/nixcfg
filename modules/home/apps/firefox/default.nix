{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.apps.firefox.enable = lib.mkEnableOption "Firefox web browser.";

  config = lib.mkIf config.myHome.apps.firefox.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts =
        lib.optionals (config.myHome.desktop.gnome.enable) [pkgs.gnome-browser-connector]
        ++ lib.optional (config.myHome.apps.keepassxc.enable) pkgs.keepassxc;
    };
  };
}
