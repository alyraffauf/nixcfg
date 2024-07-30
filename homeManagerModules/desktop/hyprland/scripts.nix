{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  pkill = lib.getExe' pkgs.procps "pkill";
  virtKeyboard = lib.getExe' pkgs.squeekboard "squeekboard";
in {
  clamshell = pkgs.writeShellScript "hyprland-clamshell" ''
    NUM_MONITORS=$(${hyprctl} monitors all | grep Monitor | wc --lines)
    if [ "$1" == "on" ]; then
      if [ $NUM_MONITORS -gt 1 ]; then
        ${hyprctl} keyword monitor "eDP-1, disable"
      fi
    elif [ "$1" == "off" ]; then
    ${
      lib.strings.concatMapStringsSep "${hyprctl}\n"
      (monitor: ''${hyprctl} keyword monitor "${monitor}"'')
      cfg.desktop.hyprland.laptopMonitors
    }
      sleep 1
      ${pkill} -SIGUSR2 waybar
    fi
  '';

  idleD = let
    timeouts =
      ["timeout 120 '${lib.getExe pkgs.brightnessctl} -s set 10' resume '${lib.getExe pkgs.brightnessctl} -r'"]
      ++ (
        if cfg.desktop.hyprland.autoSuspend
        then ["timeout 600 '${lib.getExe' pkgs.systemd "systemctl"} suspend'"]
        else [
          "timeout 600 '${lib.getExe pkgs.swaylock}'"
          "timeout 630 '${hyprctl} dispatch dpms off' resume '${hyprctl} dispatch dpms on'"
        ]
      );

    beforeSleeps =
      lib.optionals cfg.desktop.hyprland.autoSuspend
      [
        "before-sleep '${lib.getExe pkgs.playerctl} pause'"
        "before-sleep '${lib.getExe pkgs.swaylock}'"
      ];
  in
    pkgs.writeShellScript "hyprland-idled"
    "${lib.getExe pkgs.swayidle} -w lock '${lib.getExe pkgs.swaylock}' ${lib.strings.concatStringsSep " " (timeouts ++ beforeSleeps)}";

  tablet = pkgs.writeShellScript "hyprland-tablet" ''
    STATE=`${lib.getExe pkgs.dconf} read /org/gnome/desktop/a11y/applications/screen-keyboard-enabled`

    if [ $STATE -z ] || [ $STATE == "false" ]; then
      if ! [ `pgrep -f ${virtKeyboard}` ]; then
        ${virtKeyboard} &
      fi
      ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled true
    elif [ $STATE == "true" ]; then
      ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled false
    fi
  '';
}
