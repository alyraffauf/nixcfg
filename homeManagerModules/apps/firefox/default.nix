{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.firefox.enable {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts =
        lib.optionals (config.alyraffauf.apps.keepassxc.enable) [pkgs.keepassxc]
        ++ lib.optionals (config.alyraffauf.desktop.gnome.enable) [pkgs.gnome-browser-connector];
    };
  };
}
