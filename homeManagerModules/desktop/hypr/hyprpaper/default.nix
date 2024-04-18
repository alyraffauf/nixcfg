{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./hyprpaper-random.nix];

  options = {
    alyraffauf.desktop.hyprland.hyprpaper.enable =
      lib.mkEnableOption "Enables hyprpaper and assorted wallpapers.";
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.hyprpaper.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [hyprpaper];

    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
