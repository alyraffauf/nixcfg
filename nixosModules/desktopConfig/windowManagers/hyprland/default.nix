{ pkgs, lib, config, ... }: {

  options = {
    desktopConfig.windowManagers.hyprland.enable =
      lib.mkEnableOption "Enables hyprland window manager session.";
  };

  config = lib.mkIf config.desktopConfig.windowManagers.hyprland.enable {

    desktopConfig.displayManagers.lightdm.enable = lib.mkDefault true;

    programs.hyprland.enable = true;

    services.dbus.packages = [ pkgs.gcr ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
