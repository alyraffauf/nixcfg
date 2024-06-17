{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.keepassxc.enable {
    home.packages = [pkgs.keepassxc];

    xdg.configFile."keepassxc/keepassxc.ini".text =
      lib.generators.toINI {}
      config.alyraffauf.apps.keepassxc.settings;
  };
}
