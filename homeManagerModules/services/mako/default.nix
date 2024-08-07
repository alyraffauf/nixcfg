{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.mako.enable {
    services.mako = {
      actions = true;
      anchor = "top-center";
      backgroundColor = "${cfg.theme.colors.background}99";
      borderColor = "${cfg.theme.colors.primary}CC";
      borderRadius = 10;
      borderSize = 2;
      defaultTimeout = 10000;
      enable = true;
      font = "${cfg.theme.sansFont.name} Regular ${toString cfg.theme.sansFont.size}";
      height = 300;
      iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus/";
      icons = true;
      layer = "top";
      margin = "20,0";
      padding = "15";
      textColor = "${cfg.theme.colors.text}";
      width = 400;

      extraConfig = ''
        on-notify=exec ${lib.getExe pkgs.mpv} ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message.oga

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
