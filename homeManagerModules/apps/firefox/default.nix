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
        lib.optional (config.ar.home.apps.keepassxc.enable) pkgs.keepassxc;
    };
  };
}
