{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.ar.home.desktop.hyprland.enable || config.ar.home.desktop.sway.enable) {
    ar.home = {
      apps = {
        kitty.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
      };

      services = {
        mako.enable = lib.mkDefault true;
        pipewire-inhibit.enable = lib.mkDefault true;
        swayidle.enable = lib.mkDefault true;
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "";
        "org/gnome/nm-applet".disable-connected-notifications = true;
      };
    };

    home.packages = with pkgs; [
      blueberry
      gnome.file-roller
      networkmanagerapplet
      swayosd
    ];

    services = {
      playerctld.enable = lib.mkDefault true;
      swayosd.enable = lib.mkDefault true;
    };

    systemd.user.services.swayosd = {
      Install.WantedBy = lib.mkForce ["hyprland-session.target" "sway-session.target"];
      Service = {
        Restart = lib.mkForce "on-failure";
        RestartSec = 5;
      };
    };

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
