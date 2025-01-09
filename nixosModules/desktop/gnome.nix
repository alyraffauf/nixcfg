{
  config,
  lib,
  self,
  ...
}: {
  imports = [self.nixosModules.nixos-desktop-gui];

  home-manager.sharedModules = [
    {
      ar.home.desktop.gnome.enable = lib.mkDefault true;
    }
  ];

  programs.firefox.policies.Preferences."browser.tabs.inTitlebar" = lib.mkIf (config.programs.firefox.enable) 1;

  services.xserver.desktopManager.gnome.enable = true;
}
