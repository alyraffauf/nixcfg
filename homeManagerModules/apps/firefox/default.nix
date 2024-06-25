{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.firefox.enable {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = lib.optionals (config.alyraffauf.apps.keepassxc.enable) [pkgs.keepassxc];
    };
  };
}
