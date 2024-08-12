{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
in {
  config = lib.mkIf cfg.services.swayidle.enable {
    services.swayidle = {
      enable = true;

      events = [
        {
          event = "before-sleep";
          command = "${lib.getExe pkgs.playerctl} pause";
        }
        {
          event = "before-sleep";
          command = "${lib.getExe pkgs.gtklock} && ${lib.getExe' pkgs.coreutils "sleep"} 2";
        }
        {
          event = "lock";
          command = "${lib.getExe pkgs.gtklock}";
        }
      ];

      timeouts =
        [
          {
            timeout = 120;
            command = "${lib.getExe pkgs.brightnessctl} -s set 10";
            resumeCommand = "${lib.getExe pkgs.brightnessctl} -r";
          }
        ]
        ++ lib.optional cfg.desktop.autoSuspend {
          timeout = 600;
          command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend)
        {
          timeout = 600;
          command = "${lib.getExe pkgs.gtklock}";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend && cfg.desktop.hyprland.enable)
        {
          timeout = 630;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend && cfg.desktop.sway.enable)
        {
          timeout = 630;
          command = "${swaymsg} \"output * dpms off\"";
          resumeCommand = "${swaymsg} \"output * dpms on\"";
        };
    };

    systemd.user.services.swayidle = {
      Install.WantedBy = lib.mkForce ["hyprland-session.target" "sway-session.target"];
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = ["hyprland-session.target" "sway-session.target"];
    };
  };
}
