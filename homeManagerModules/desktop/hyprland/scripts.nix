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
        then ["timeout 600 'sleep 2 && ${lib.getExe' pkgs.systemd "systemctl"} suspend'"]
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
    "${lib.getExe pkgs.swayidle} -w ${lib.strings.concatStringsSep " " (timeouts ++ beforeSleeps)}";

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

  wallpaperD =
    if cfg.desktop.hyprland.randomWallpaper
    then
      pkgs.writers.writeRuby "hyprland-randomWallpaper" {} ''
        require 'fileutils'

        directory = "${config.xdg.dataHome}/backgrounds/"
        hyprctl = "${hyprctl}"
        current_pids = {}
        known_monitors = {}
        last_update_time = {}

        update_interval = 900 # 15 minutes in seconds

        sleep 1

        if Dir.exist?(directory)
          loop do
            outputs = IO.popen([hyprctl, 'monitors']).read
            active_monitors = outputs.each_line.map { |line| line.split[1] if line.include?('Monitor') }.compact

            added_monitors = active_monitors - known_monitors.keys
            removed_monitors = known_monitors.keys - active_monitors

            # Handle newly added monitors
            added_monitors.each do |monitor|
              random_background = Dir.glob(File.join(directory, '*.{png,jpg}')).sample
              pid = spawn("${lib.getExe pkgs.swaybg}", '-o', monitor, '-i', random_background, '-m', 'fill')
              current_pids[monitor] = pid
              last_update_time[monitor] = Time.now
              known_monitors[monitor] = random_background
            end

            # Remove wallpapers from removed monitors
            removed_monitors.each do |monitor|
              Process.kill('TERM', current_pids[monitor]) if current_pids[monitor]
              current_pids.delete(monitor)
              last_update_time.delete(monitor)
              known_monitors.delete(monitor)
            end

            # Update wallpapers after the set interval
            active_monitors.each do |monitor|
              if Time.now - last_update_time[monitor] >= update_interval
                random_background = Dir.glob(File.join(directory, '*.{png,jpg}')).sample
                pid = spawn("${lib.getExe pkgs.swaybg}", '-o', monitor, '-i', random_background, '-m', 'fill')
                sleep 1
                Process.kill('TERM', current_pids[monitor]) if current_pids[monitor]
                current_pids[monitor] = pid
                last_update_time[monitor] = Time.now
                known_monitors[monitor] = random_background
              end
            end

            sleep 5 # Check for monitor changes and update intervals every 5 seconds
          end
        end
      ''
    else "${lib.getExe pkgs.swaybg} -i ${cfg.theme.wallpaper}";
}
