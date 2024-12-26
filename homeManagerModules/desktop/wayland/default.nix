{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.ar.home.desktop.hyprland.enable) {
    ar.home = {
      apps = {
        kitty.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
      };

      services = {
        hypridle.enable = lib.mkDefault config.ar.home.desktop.hyprland.enable;
        mako.enable = lib.mkDefault true;
        pipewire-inhibit.enable = lib.mkDefault true;
        swayosd.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
      };
    };

    home.packages = with pkgs; [
      blueberry
      file-roller
      libnotify
      networkmanagerapplet
    ];

    programs.hyprlock.settings = {
      auth.fingerprint.enabled = true;
    };

    services.playerctld.enable = lib.mkDefault true;

    xdg.portal = {
      enable = true;
      configPackages =
        lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
      extraPortals =
        [pkgs.xdg-desktop-portal-gtk]
        ++ lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
