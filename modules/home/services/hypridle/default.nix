{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.services.hypridle.enable = lib.mkEnableOption "Hypridle idle daemon.";

  config = lib.mkIf cfg.services.hypridle.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
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
    };

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          lock_cmd = "pidof hyprlock || hyprlock --immediate --no-fade-in";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener =
          [
            {
              timeout = 30;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd chromeos::kbd_backlight set 0";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd chromeos::kbd_backlight";
            }
            {
              timeout = 30;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd platform::kbd_backlight set 0";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd platform::kbd_backlight";
            }
            {
              timeout = 60;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
            }
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 360;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ]
          ++ lib.optional cfg.desktop.autoSuspend {
            timeout = 600;
            on-timeout = "systemctl suspend";
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
                brightnessctl # Not working as of 2025-01-25, needs nixpkgs interpolation to work.
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
