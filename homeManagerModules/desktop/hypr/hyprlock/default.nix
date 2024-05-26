{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    alyraffauf.desktop.hyprland.hyprlock.enable =
      lib.mkEnableOption "Enables hyprlock.";
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.hyprlock.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".hyprlock];

    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
  };
}
