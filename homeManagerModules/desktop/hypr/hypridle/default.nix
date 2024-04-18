{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.hyprland.hypridle.enable =
      lib.mkEnableOption "Enables hypridle.";
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.hypridle.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [hypridle brightnessctl];

    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = ${pkgs.systemd}/bin/loginctl lock-session    # lock before suspend.
          after_sleep_cmd = ${pkgs.hyprland}/bin/hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
      }

      listener {
          timeout = 150                                # 2.5min.
          on-timeout = ${pkgs.brightnessctl}/bin/brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = ${pkgs.brightnessctl}/bin/brightnessctl -r                 # monitor backlight restor.
      }

      # turn off keyboard backlight, uncomment this section if have keyboard backlight.
      #listener {
      #    timeout = 150                                          # 2.5min.
      #    on-timeout = ${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
      #    on-resume = ${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
      #}

      listener {
          timeout = 300                                 # 5min
          on-timeout = ${pkgs.systemd}/bin/loginctl lock-session            # lock screen when timeout has passed
      }

      listener {
          timeout = 360                                 # 5.5min
          on-timeout = ${pkgs.hyprland}/bin/hyprctl dispatch dpms off        # screen off when timeout has passed
          on-resume = ${pkgs.hyprland}/bin/hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
      }

      listener {
          timeout = 900                                 # 15min
          on-timeout = grep [[ $(${pkgs.nettools}/bin/hostname) != "mauville" ]] && ${pkgs.systemd}/bin/systemctl suspend # suspend pc unless on mauville
      }
    '';
  };
}
