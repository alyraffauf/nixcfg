{
  pkgs,
  lib,
  config,
  ...
}: let
  hyprbg-randomWallpaper = pkgs.writeShellScriptBin "hyprbg-randomWallpaper" ''
    kill `pidof swaybg`

    OLD_PIDS=()
    directory=${config.home.homeDirectory}/.local/share/backgrounds

    if [ -d "$directory" ]; then
        while true; do
          NEW_PIDS=()
          monitor=`${config.wayland.windowManager.hyprland.package}/bin/hyprctl monitors | grep Monitor | awk '{print $2}'`
          for m in ''${monitor[@]}; do
            random_background=$(ls $directory/*.{png,jpg} | shuf -n 1)
            ${lib.getExe pkgs.swaybg} -o $m -i $random_background &
            NEW_PIDS+=($!)
          done

          sleep 5

          for pid in ''${OLD_PIDS[@]}; do
            kill $pid
          done

          OLD_PIDS=$NEW_PIDS

          sleep 895
        done
    fi
  '';
in {
  config = lib.mkIf config.alyraffauf.desktop.hyprland.randomWallpaper {
    home.packages = with pkgs; [swaybg hyprbg-randomWallpaper];

    wayland.windowManager.hyprland.extraConfig = "exec-once = ${lib.getExe hyprbg-randomWallpaper}";
  };
}
