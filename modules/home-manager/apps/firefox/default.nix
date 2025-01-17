{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.firefox.enable {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts =
        lib.optionals (config.ar.home.desktop.gnome.enable) [pkgs.gnome-browser-connector]
        ++ lib.optional (config.ar.home.apps.keepassxc.enable) pkgs.keepassxc;
    };
  };
}
