{
  config,
  lib,
  pkgs,
  ...
}: {
  brightness = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --brightness=raise";
    down = "${bin} --brightness=lower";
  };

  media = rec {
    bin = lib.getExe pkgs.playerctl;
    play = "${bin} play-pause";
    paus = "${bin} pause";
    next = "${bin} next";
    prev = "${bin} previous";
  };

  screenshot = pkgs.writeShellScript "screenshooter" ''
    FILENAME=${config.xdg.userDirs.pictures}/screenshots/$(date +'%Y-%m-%d-%H:%M:%S_grim.png')
    MAKO_MODE=$(${lib.getExe' pkgs.mako "makoctl"} mode)

    if echo "$MAKO_MODE" | grep -q "do-not-disturb"; then
      DND=true
    else
      DND=false
      ${lib.getExe' pkgs.mako "makoctl"} mode -t do-not-disturb
    fi

    ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -o)" "$FILENAME"

    if [ "$DND" = false ]; then
      ${lib.getExe' pkgs.mako "makoctl"} mode -t do-not-disturb
    fi

    if [ -e "$FILENAME" ]; then
      ${lib.getExe' pkgs.wl-clipboard-rs "wl-copy"} -t image/png < $FILENAME
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot saved" "$FILENAME" -i "$FILENAME"
    fi
  '';

  volume = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --output-volume=raise";
    down = "${bin} --output-volume=lower";
    mute = "${bin} --output-volume=mute-toggle";
    micMute = "${bin} --input-volume=mute-toggle";
  };

  wallpaperD = pkgs.writers.writeRuby "randomWallpaperD" {} ''
    require 'fileutils'

    directory = "${config.xdg.dataHome}/backgrounds/"
    current_pids = {}
    known_monitors = {}
    last_update_time = {}

    update_interval = 900 # 15 minutes in seconds

    def process_running?(process_name)
      system("pidof #{process_name} > /dev/null 2>&1")
    end

    def get_outputs
      if process_running?("sway")
        outputs = IO.popen(["${lib.getExe' config.wayland.windowManager.sway.package "swaymsg"}", '-t', 'get_outputs', '-p']).readlines
        outputs.select { |line| line.include?('Output') }.map { |line| line.split[1] }
      elsif process_running?("Hyprland")
        outputs = IO.popen(["${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"}", 'monitors']).read
        outputs.each_line.map { |line| line.split[1] if line.include?('Monitor') }.compact
      end
    end

    sleep 1

    if Dir.exist?(directory)
      loop do
        active_monitors = get_outputs

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
  '';
}
