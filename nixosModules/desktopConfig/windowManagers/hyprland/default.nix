{ pkgs, lib, config, ... }: {

  options = {
    desktopConfig.windowManagers.hyprland.enable = lib.mkEnableOption
      "Enables hyprland window manager session.";
  };

  config = lib.mkIf config.desktopConfig.windowManagers.hyprland.enable {

    desktopConfig.displayManagers.lightdm.enable = lib.mkDefault true;
    
    programs.hyprland.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    services.dbus.packages = [ pkgs.gcr ];

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableKwallet = true;
    security.pam.services.gdm.enableGnomeKeyring = true;

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
