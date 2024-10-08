{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.swayidle.enable {
    services.swayidle = {
      enable = true;

      events = [
        {
          event = "before-sleep";
          command = "playerctl pause";
        }
        {
          event = "before-sleep";
          command = "swaylock && sleep 2";
        }
        {
          event = "lock";
          command = "swaylock";
        }
      ];

      timeouts =
        [
          {
            timeout = 120;
            command = "brightnessctl -s set 10";
            resumeCommand = "brightnessctl -r";
          }
        ]
        ++ lib.optional cfg.desktop.autoSuspend {
          timeout = 600;
          command = "systemctl suspend";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend)
        {
          timeout = 600;
          command = "swaylock";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend && cfg.desktop.hyprland.enable)
        {
          timeout = 630;
          command = "hyprctl dispatch dpms off";
          resumeCommand = "hyprctl dispatch dpms on";
        }
        ++ lib.optional (!cfg.desktop.autoSuspend && cfg.desktop.sway.enable)
        {
          timeout = 630;
          command = "swaymsg \"output * dpms off\"";
          resumeCommand = "swaymsg \"output * dpms on\"";
        };
    };

    systemd.user.services.swayidle = {
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target");

      Service = {
        Environment = lib.mkForce [
          "PATH=${
            lib.makeBinPath ((with pkgs; [
                bash
                brightnessctl
                coreutils
                playerctl
                swaylock
                systemd
              ])
              ++ lib.optional (cfg.desktop.hyprland.enable) config.wayland.windowManager.hyprland.package
              ++ lib.optional (cfg.desktop.sway.enable) config.wayland.windowManager.sway.package)
          }"
        ];
        Restart = lib.mkForce "no";
      };

      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target";
    };
  };
}
