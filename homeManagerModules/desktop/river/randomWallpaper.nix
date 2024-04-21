{
  pkgs,
  lib,
  config,
  ...
}: let
  swaybg-random = pkgs.writeShellScriptBin "swaybg-random" ''
    directory=${config.home.homeDirectory}/.local/share/backgrounds

    if [ -d "$directory" ]; then
        while true; do
          kill `pidof swaybg`
          random_background=$(ls $directory/*.{png,jpg} | shuf -n 1)
          swaybg -i $random_background &
          sleep 300
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
