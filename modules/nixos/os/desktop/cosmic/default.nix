{
  config,
  lib,
  ...
}: {
  options.myNixOS.desktop.cosmic.enable = lib.mkEnableOption "COSMIC desktop environment";

  config = lib.mkIf config.myNixOS.desktop.cosmic.enable {
    home-manager.sharedModules = [
      {
        config.myHome.desktop.cosmic.enable = true;
      }
    ];

    programs.firefox.policies.Preferences."browser.tabs.inTitlebar" = lib.mkIf config.programs.firefox.enable 1;
    services.desktopManager.cosmic.enable = true;
    system.nixos.tags = ["cosmic"];
    myNixOS.desktop.enable = true;
  };
}
