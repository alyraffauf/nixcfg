{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  config = lib.mkIf cfg.services.hypridle.enable {
    programs.hyprlock.settings = {
      enable = true;

      auth.fingerprint = {
        enabled = true;
        present_message = "Scanning fingerprint...";
        ready_message = "Scan fingerprint to unlock.";
      };

      input-field = {
        font_family = config.stylix.fonts.sansSerif.name;
        rounding = config.myHome.theme.borders.radius;
      };

      shape = [
        {
          border_color = "rgb(${config.lib.stylix.colors.base0D})";
          border_size = 8;
          color = "rgb(${config.lib.stylix.colors.base00})";
          halign = "center";
          position = "-33%, 0";
          rotate = 0;
          rounding = config.myHome.theme.borders.radius;
          shadow_color = "rgb(${config.lib.stylix.colors.base01})";
          shadow_passes = 3;
          size = "600, 600";
          valign = "center";
          xray = false;
        }
      ];

      label = [
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 40;
          halign = "center";
          position = "-33%, 200";
          shadow_passes = 0;
          text = "Hi $DESC 👋";
          valign = "center";
        }
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 40;
          halign = "center";
          position = "-33%, -200";
          shadow_passe = 0;
          text = "It is $TIME12.";
          valign = "center";
        }
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 24;
          halign = "center";
          position = "-33%, 0";
          shadow_passes = 0;
          text = "$FPRINTMESSAGE";
          valign = "center";
        }
      ];
    };

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
              timeout = 30;
              on-timeout = "brightnessctl -sd platform::kbd_backlight set 0";
              on-resume = "brightnessctl -rd platform::kbd_backlight";
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
            on-timeout = "systemctl suspend";
          }
          ++ lib.optional
          (!cfg.desktop.autoSuspend) {
            timeout = 630;
            on-timeout = "hyprctl dispatch dpms off";
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
