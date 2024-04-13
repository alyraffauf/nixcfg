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
    desktopEnv.river.randomWallpaper.enable =
      lib.mkEnableOption "Enables swaybg random wallpaper script.";
  };

  config = lib.mkIf config.desktopEnv.river.randomWallpaper.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [swaybg swaybg-random];

    wayland.windowManager.river.extraConfig = "swaybg-random &";
  };
}
