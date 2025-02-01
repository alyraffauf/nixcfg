{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.firefox.enable = lib.mkEnableOption "Firefox web browser.";

  config = lib.mkIf config.myHome.programs.firefox.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts =
        lib.optionals (config.myHome.desktop.gnome.enable) [pkgs.gnome-browser-connector]
        ++ lib.optional (config.myHome.programs.keepassxc.enable) pkgs.keepassxc;
    };
  };
}
