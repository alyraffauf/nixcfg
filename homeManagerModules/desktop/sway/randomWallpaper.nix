{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  sway-randomWallpaper = pkgs.writeShellScriptBin "sway-randomWallpaper" ''
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
in {
  config = lib.mkIf config.ar.home.desktop.sway.randomWallpaper {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [swaybg sway-randomWallpaper];

    wayland.windowManager.sway.config.startup = [
      {command = "${lib.getExe sway-randomWallpaper}";}
    ];
  };
}
