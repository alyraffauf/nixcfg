{
  config,
  lib,
  self,
  ...
}: {
  imports = [self.nixosModules.nixos-desktop];

  config = {
    home-manager.sharedModules = [
      {
        config.myHome.desktop.gnome.enable = true;
      }
    ];

    programs.firefox.policies.Preferences."browser.tabs.inTitlebar" = lib.mkIf (config.programs.firefox.enable) 1;

    services.xserver.desktopManager.gnome.enable = true;
  };
}
