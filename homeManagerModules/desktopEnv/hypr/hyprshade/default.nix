{ pkgs, lib, config, ... }: {

  options = {
    desktopEnv.hyprland.hyprshade.enable =
      lib.mkEnableOption "Enables hyprshade with blue light filter.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.hyprshade.enable {

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      hyprshade
    ];

    xdg.configFile."hypr/shaders/blue-light-filter.glsl".source =
      ./blue-light-filter.glsl;
    xdg.configFile."hypr/hyprshade.toml".source = ./hyprshade.toml;
  };
}
