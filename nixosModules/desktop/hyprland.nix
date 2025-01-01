{pkgs, ...}: {
  imports = [./gui.nix];

  programs = {
    gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
    hyprland.enable = true;
    hyprlock.enable = true;
  };

  services = {
    dbus.packages = [pkgs.gcr];
    udev.packages = [pkgs.swayosd];
  };
}
