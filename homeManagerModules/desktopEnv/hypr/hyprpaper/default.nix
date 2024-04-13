{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./hyprpaper-random.nix];

  options = {
    desktopEnv.hyprland.hyprpaper.enable =
      lib.mkEnableOption "Enables hyprpaper and assorted wallpapers.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.hyprpaper.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [hyprpaper];

    desktopEnv.hyprland.hyprpaper.randomWallpaper.enable = lib.mkDefault true;

    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
