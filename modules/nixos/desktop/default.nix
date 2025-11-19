{
  config,
  lib,
  ...
}: {
  imports = [
    ./cosmic
    ./gnome
    ./hyprland
    ./kde
  ];

  options.myNixOS.desktop.enable = lib.mkOption {
    default = config.myNixOS.desktop.cosmic.enable or  config.myNixOS.desktop.gnome.enable or config.myNixOS.desktop.hyprland.enable or config.myNixOS.desktop.kde.enable;
    description = "Desktop environment configuration.";
    type = lib.types.bool;
  };

  config = lib.mkIf config.myNixOS.desktop.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    home-manager.sharedModules = [
      {
        config.myHome.desktop.enable = true;
      }
    ];

    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true; # Mount, trash, etc.
      libinput.enable = true;
    };

    systemd.user.services.orca.wantedBy = lib.mkForce [];

    myNixOS = {
      profiles = {
        appimage.enable = true;
        audio.enable = true;
        graphical-boot.enable = true;
        printing.enable = true;
      };

      services.avahi.enable = true;
    };
  };
}
