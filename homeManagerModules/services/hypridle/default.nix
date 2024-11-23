{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.hypridle.enable {
    programs.hyprlock.enable = true;

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          lock_cmd = "hyprlock";
          before_sleep_cmd = "hyprlock --immediate --no-fade-in";
        };

        listener =
          [
            {
              timeout = 30;
              on-timeout = "brightnessctl -sd chromeos::kbd_backlight set 0";
              on-resume = "brightnessctl -rd chromeos::kbd_backlight";
            }
            {
              timeout = 120;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
          ]
          ++ lib.optional (!cfg.desktop.autoSuspend) {
            timeout = 600;
            on-timeout = "hyprlock";
          }
          ++ lib.optional cfg.desktop.autoSuspend {
            timeout = 600;
            command = "systemctl suspend";
          }
          ++ lib.optional
          (!cfg.desktop.autoSuspend) {
            timeout = 600;
            on-timeout = "hyprlock";
          }
          ++ lib.optional (!cfg.desktop.autoSuspend && cfg.desktop.hyprland.enable)
          {
            timeout = 630;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          };
      };
    };

    systemd.user.services.hypridle = {
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target");

      Service = {
        Environment = lib.mkForce [
          "PATH=${
            lib.makeBinPath (
              (with pkgs; [
                bash
                brightnessctl
                coreutils
                hyprlock
                systemd
              ])
              ++ lib.optional (cfg.desktop.hyprland.enable) config.wayland.windowManager.hyprland.package
            )
          }"
        ];
        Restart = lib.mkForce "no";
      };

      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target";
    };
  };
}
