{
  pkgs,
  lib,
  config,
  ...
}: let
  swaybg-random = pkgs.writeShellScriptBin "swaybg-random" ''
    kill `pidof swaybg`

    OLD_PIDS=()
    directory=${config.home.homeDirectory}/.local/share/backgrounds

    if [ -d "$directory" ]; then
        while true; do
          NEW_PIDS=()

          random_background=$(ls $directory/*.{png,jpg} | shuf -n 1)
          ${pkgs.swaybg}/bin/swaybg -i $random_background &
          NEW_PIDS+=($!)

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
  options = {
    alyraffauf.desktop.river.randomWallpaper =
      lib.mkEnableOption "Enables swaybg random wallpaper script.";
  };

  config = lib.mkIf config.alyraffauf.desktop.river.randomWallpaper {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [swaybg swaybg-random];

    wayland.windowManager.river.extraConfig = ''
      kill `ps aux | grep swaybg-random | grep -v grep | awk '{print $2}'`
      swaybg-random &
    '';
  };
}
