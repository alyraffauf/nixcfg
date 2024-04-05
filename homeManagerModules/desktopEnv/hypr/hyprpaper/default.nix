{ pkgs, lib, config, ... }: {

  imports = [ ./hyprpaper-random.nix ];

  options = {
    desktopEnv.hyprland.hyprpaper.enable =
      lib.mkEnableOption "Enables hyprpaper and assorted wallpapers.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.hyprpaper.enable {

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [ hyprpaper ];

    desktopEnv.hyprland.hyprpaper.randomWallpaper.enable = lib.mkDefault true;

    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;

    xdg.configFile."hypr/wallpapers/evening-sky.png".source =
      ./wallpapers/evening-sky.png;
    xdg.configFile."hypr/wallpapers/jr-korpa-9XngoIpxcEo-unsplash.jpg".source =
      ./wallpapers/jr-korpa-9XngoIpxcEo-unsplash.jpg;
    xdg.configFile."hypr/wallpapers/wallhaven-6d7xmx.jpg".source =
      ./wallpapers/wallhaven-6d7xmx.jpg;
    xdg.configFile."hypr/wallpapers/wallhaven-83v96o.png".source =
      ./wallpapers/wallhaven-83v96o.png;
    xdg.configFile."hypr/wallpapers/wallhaven-285rjm.jpg".source =
      ./wallpapers/wallhaven-285rjm.jpg;
    xdg.configFile."hypr/wallpapers/wallhaven-4219wy.jpg".source =
      ./wallpapers/wallhaven-4219wy.jpg;
    xdg.configFile."hypr/wallpapers/wallhaven-4267k6.jpg".source =
      ./wallpapers/wallhaven-4267k6.jpg;
    xdg.configFile."hypr/wallpapers/wallhaven-d6ggel.jpg".source =
      ./wallpapers/wallhaven-d6ggel.jpg;
    xdg.configFile."hypr/wallpapers/wallhaven-q2o2w5.jpg".source =
      ./wallpapers/wallhaven-q2o2w5.jpg;
    xdg.configFile."hypr/wallpapers/wallhaven-zm7x5o.jpg".source =
      ./wallpapers/wallhaven-zm7x5o.jpg;
  };
}
