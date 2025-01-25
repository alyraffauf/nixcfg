{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.myHome.desktop.hyprland.enable) {
    myHome = {
      apps = {
        kitty.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
      };

      services = {
        hypridle.enable = lib.mkDefault config.myHome.desktop.hyprland.enable;
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

    services.playerctld.enable = lib.mkDefault true;

    xdg.portal = {
      enable = true;
      configPackages =
        lib.optional (config.myHome.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
      extraPortals =
        [pkgs.xdg-desktop-portal-gtk]
        ++ lib.optional (config.myHome.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
