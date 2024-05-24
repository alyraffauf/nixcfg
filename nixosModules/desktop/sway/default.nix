{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.sway.enable =
      lib.mkEnableOption "Sway wayland compositor.";
  };

  config = lib.mkIf config.alyraffauf.desktop.sway.enable {
    services = {
      blueman.enable = true;
      dbus.packages = [pkgs.gcr];
      geoclue2.enable = true;
      gnome.gnome-keyring.enable = true;
      udev.packages = [pkgs.swayosd];
    };

    security.pam.services = {
      greetd.enableKwallet = true;
      greetd.enableGnomeKeyring = true;
      swaylock = {};
    };

    programs = {
      gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
      sway = {
        enable = true;
        package = inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".swayfx;
      };
    };
  };
}
