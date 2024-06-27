{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.firefox.enable {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts =
        lib.optionals (config.ar.home.apps.keepassxc.enable) [pkgs.keepassxc]
        ++ lib.optionals (config.ar.home.desktop.gnome.enable) [pkgs.gnome-browser-connector];
    };
  };
}
