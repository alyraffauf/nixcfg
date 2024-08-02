{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.services.mako.enable {
    services.mako = {
      enable = true;
      anchor = "top-center";
      backgroundColor = "${config.ar.home.theme.colors.background}CC";
      borderColor = "${config.ar.home.theme.colors.primary}EE";
      borderSize = 2;
      borderRadius = 10;
      defaultTimeout = 10000;
      font = "${config.gtk.font.name} Regular ${toString config.gtk.font.size}";
      height = 300;
      layer = "top";
      padding = "15";
      textColor = "${config.ar.home.theme.colors.text}";
      width = 400;
      margin = "20,0";
      extraConfig = ''
        [mode=do-not-disturb]
        invisible=1
      '';
    };

    systemd.user.services.mako = {
      Unit = {
        After = "graphical-session.target";
        Description = "Lightweight Wayland notification daemon";
        Documentation = "man:mako(1)";
        PartOf = "graphical-session.target";
      };

      Service = {
        BusName = "org.freedesktop.Notifications";
        ExecReload = ''${lib.getExe' pkgs.mako "makoctl"} reload'';
        ExecStart = "${lib.getExe pkgs.mako}";
        Restart = "on-failure";
        RestartSec = 5;
        Type = "dbus";
      };

      Install.WantedBy = ["hyprland-session.target" "sway-session.target"];
    };
  };
}
