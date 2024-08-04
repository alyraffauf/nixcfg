{
  config,
  lib,
  pkgs,
  ...
}: let
  wallpaperD = pkgs.writers.writeRuby "randomWallpaperD" {} ''
    require 'fileutils'

    directory = "${config.xdg.dataHome}/backgrounds/"
    current_pids = {}
    known_monitors = {}
    last_update_time = {}

    update_interval = 900 # 15 minutes in seconds

    def get_outputs
      hyprctl = IO.popen(["${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"}", 'monitors']).read
      swaymsg = IO.popen(["${lib.getExe' config.wayland.windowManager.sway.package "swaymsg"}", '-t', 'get_outputs', '-p']).readlines
      hypr_outputs = hyprctl.each_line.map { |line| line.split[1] if line.include?('Monitor') }.compact
      sway_outputs = swaymsg.select { |line| line.include?('Output') }.map { |line| line.split[1] }
      return sway_outputs | hypr_outputs
    end

    sleep 1

    if Dir.exist?(directory)
      loop do
        active_monitors = get_outputs
        break if active_monitors.empty?

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

        sleep 3
      end
    end
  '';
in {
  config = lib.mkIf config.ar.home.services.randomWallpaper.enable {
    systemd.user.services.randomWallpaper = {
      Unit = {
        After = "graphical-session.target";
        Description = "Lightweight swaybg-based random wallpaper daemon.";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${wallpaperD}";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install.WantedBy = ["hyprland-session.target" "sway-session.target"];
    };
  };
}