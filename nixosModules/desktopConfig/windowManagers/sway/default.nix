{ pkgs, lib, config, ... }: {

  options = {
    desktopConfig.windowManagers.sway.enable =
      lib.mkEnableOption "Sway window manager session.";
  };

  config = lib.mkIf config.desktopConfig.windowManagers.sway.enable {

    desktopConfig.displayManagers.lightdm.enable = lib.mkDefault true;

    programs.sway.enable = true;

    services.dbus.packages = [ pkgs.gcr ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
