{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.hyprland.enable =
      lib.mkEnableOption "Hyprland wayland compositor.";
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.enable {
    services = {
      dbus.packages = [pkgs.gcr];
      udev.packages = [pkgs.swayosd];
      gnome.gnome-keyring.enable = true;
      blueman.enable = true;
    };

    security.pam.services = {
      greetd.enableKwallet = true;
      greetd.enableGnomeKeyring = true;
      swaylock = {};
    };

    programs = {
      gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
      hyprland = {
        enable = true;
        package = inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".hyprland;
      };
    };
  };
}
