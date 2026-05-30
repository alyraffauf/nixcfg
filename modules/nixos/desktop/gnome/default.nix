{
  config,
  lib,
  ...
}: {
  options.myNixOS.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.myNixOS.desktop.gnome.enable {
    programs.firefox.policies.Preferences."browser.tabs.inTitlebar" = lib.mkIf config.programs.firefox.enable 1;
    services.desktopManager.gnome.enable = true;
    system.nixos.tags = ["gnome"];
    myNixOS.desktop.enable = true;
  };
}
