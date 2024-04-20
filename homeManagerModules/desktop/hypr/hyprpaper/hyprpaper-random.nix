{
  pkgs,
  lib,
  config,
  ...
}: let
  hyprpaper-random = pkgs.writeShellScriptBin "hyprpaper-random" ''
    directory=${config.home.homeDirectory}/.local/share/backgrounds
    
    if [ -d "$directory" ]; then
        while true; do
          sleep 30
          hyprctl hyprpaper unload all
          monitor=`hyprctl monitors | grep Monitor | awk '{print $2}'`
          for m in ''${monitor[@]}; do
            random_background=$(ls $directory/*.{png,jpg} | shuf -n 1)
            hyprctl hyprpaper preload $random_background
            hyprctl hyprpaper wallpaper "$m,$random_background"
          done
          sleep 870
        done
    fi
  '';
in {
  options = {
    alyraffauf.desktop.hyprland.hyprpaper.randomWallpaper.enable =
      lib.mkEnableOption "Enables hyprpaper random wallpaper script.";
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.hyprpaper.randomWallpaper.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [hyprpaper-random];

    wayland.windowManager.hyprland.extraConfig = "exec-once = ${hyprpaper-random}/bin/hyprpaper-random";
  };
}
