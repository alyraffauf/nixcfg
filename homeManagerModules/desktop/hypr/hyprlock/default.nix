{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.hyprland.hyprlock.enable =
      lib.mkEnableOption "Enables hyprlock.";
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.hyprlock.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [hyprlock];

    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
  };
}
