{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
in {
  idleD = pkgs.writeShellScript "sway-idled" ''
    ${lib.getExe pkgs.swayidle} -w \
      before-sleep '${lib.getExe pkgs.playerctl} pause' \
      before-sleep '${lib.getExe pkgs.swaylock}' \
      timeout 240 '${lib.getExe pkgs.brightnessctl} -s set 10' \
        resume '${lib.getExe pkgs.brightnessctl} -r' \
      timeout 300 '${lib.getExe pkgs.swaylock}' \
      timeout 330 '${swaymsg} "output * dpms off"' \
        resume '${swaymsg} "output * dpms on"' \
      ${
      if cfg.desktop.sway.autoSuspend
      then ''timeout 900 '${lib.getExe' pkgs.systemd "systemctl"} suspend' \''
      else ''\''
    }
  '';

  randomWallpaper = pkgs.writeShellScript "sway-randomWallpaper" ''
    kill `pidof swaybg`

    OLD_PIDS=()
    directory=${config.xdg.dataHome}/backgrounds

    if [ -d "$directory" ]; then
        while true; do
          NEW_PIDS=()

          monitor=`${lib.getExe' config.wayland.windowManager.sway.package "swaymsg"} -t get_outputs -p | grep Output | awk '{print $2}'`
          for m in ''${monitor[@]}; do
            random_background=$(ls $directory/*.{png,jpg} | shuf -n 1)
            ${lib.getExe pkgs.swaybg} -o $m -i $random_background -m fill &
            NEW_PIDS+=($!)
          done

          if [[ ''${OLD_PIDS[@]} -gt 0 ]]; then
            sleep 5
          fi

          for pid in ''${OLD_PIDS[@]}; do
            kill $pid
          done

          OLD_PIDS=$NEW_PIDS

          sleep 895
        done
    fi
  '';
}
