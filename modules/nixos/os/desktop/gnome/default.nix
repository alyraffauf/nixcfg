{
  config,
  lib,
  ...
}: {
  options.myNixOS.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.myNixOS.desktop.gnome.enable {
    home-manager.sharedModules = [
      {
        config.myHome.desktop.gnome.enable = true;
      }
    ];

    programs.firefox.policies.Preferences."browser.tabs.inTitlebar" = lib.mkIf config.programs.firefox.enable 1;
    services.desktopManager.gnome.enable = true;
    myNixOS.desktop.enable = true;
  };
}
