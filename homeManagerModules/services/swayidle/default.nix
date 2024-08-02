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
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock}/bin/swaylock";
        }
      ];

      timeouts =
        [
          {
            timeout = 120;
            command = "${lib.getExe pkgs.brightnessctl} -s set 10' resume '${lib.getExe pkgs.brightnessctl} -r";
          }
          {
            timeout = 600;
            command = "${pkgs.swaylock}/bin/swaylock";
          }
        ]
        ++ lib.optional cfg.desktop.autoSuspend {
          timeout = 600;
          command = "sleep 2 && ${lib.getExe' pkgs.systemd "systemctl"} suspend'";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend)
        {
          timeout = 600;
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend && cfg.desktop.hyprland.enable)
        {
          timeout = 630;
          command = "${hyprctl} dispatch dpms off' resume '${hyprctl} dispatch dpms on'";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend && cfg.desktop.sway.enable)
        {
          timeout = 630;
          command = "${swaymsg} \"output * dpms off\"' resume '${swaymsg} \"output * dpms on\"";
        };
    };
  };
}
