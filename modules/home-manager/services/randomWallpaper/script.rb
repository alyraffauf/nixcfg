#!/usr/bin/env ruby

require "fileutils"

# Set the wallpaper directory to the first argument if it exists, else use the default value
directory = ARGV[0] || File.expand_path("~/.local/share/backgrounds")

current_pids = {}
known_monitors = {}
last_update_time = {}

update_interval = 1800 # 30 minutes in seconds

xdg_runtime_dir = ENV["XDG_RUNTIME_DIR"]
hyprland_instance_signature = ENV["HYPRLAND_INSTANCE_SIGNATURE"]
sway_sock = ENV["SWAYSOCK"]

hyprland_lock_path = nil

unless hyprland_instance_signature.nil?
  hyprland_lock_path = File.join(xdg_runtime_dir, "hypr", hyprland_instance_signature, "hyprland.lock")
end

def wm_dead?(hyprland_lock_path, sway_sock)
  sway_running = system("pidof sway > /dev/null")
  hypr_running = system("pidof Hyprland > /dev/null")
  (hyprland_lock_path.nil? || !File.exist?(hyprland_lock_path) || !hypr_running) && (sway_sock.nil? || !File.exist?(sway_sock) || !sway_running)
end

def get_outputs
  hyprctl = IO.popen(["hyprctl", "monitors"]).read
  swaymsg = IO.popen(["swaymsg", "-t", "get_outputs", "-p"]).readlines

  hypr_outputs = hyprctl.each_line.map { |line| line.split[1] if line.include?("Monitor") }.compact
  sway_outputs = swaymsg.select { |line| line.include?("Output") }.map { |line| line.split[1] }

  return (sway_outputs | hypr_outputs)
end

sleep 1

loop do
  active_monitors = get_outputs

  break if wm_dead? hyprland_lock_path, sway_sock
  next if active_monitors.empty?

  added_monitors = active_monitors - known_monitors.keys
  removed_monitors = known_monitors.keys - active_monitors

  # Handle newly added monitors
  added_monitors.each do |monitor|
    random_background = Dir.glob(File.join(directory, "*.{png,jpg}")).sample
    pid = spawn("swaybg", "-o", monitor, "-i", random_background, "-m", "fill")
    current_pids[monitor] = pid
    last_update_time[monitor] = Time.now
    known_monitors[monitor] = random_background
  end

  # Remove wallpapers from removed monitors
  removed_monitors.each do |monitor|
    Process.kill("TERM", current_pids[monitor]) if current_pids[monitor]
    current_pids.delete(monitor)
    last_update_time.delete(monitor)
    known_monitors.delete(monitor)
  end

  # Update wallpapers after the set interval
  active_monitors.each do |monitor|
    if Time.now - last_update_time[monitor] >= update_interval
      random_background = Dir.glob(File.join(directory, "*.{png,jpg}")).sample
      pid = spawn("swaybg", "-o", monitor, "-i", random_background, "-m", "fill")
      sleep 1
      Process.kill("TERM", current_pids[monitor]) if current_pids[monitor]
      current_pids[monitor] = pid
      last_update_time[monitor] = Time.now
      known_monitors[monitor] = random_background
    end
  end

  sleep 5
end
