{ pkgs, lib, config, ... }: {

  options = {
    desktopEnv.hyprland.hyprpaper.enable =
      lib.mkEnableOption "Enables hyprpaper and assorted wallpapers.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.hyprpaper.enable {

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [ hyprpaper ];

    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;

    xdg.configFile."hypr/wallpapers/greenCity.jpg".source =
      ./wallpapers/greenCity.jpg;
    xdg.configFile."hypr/wallpapers/jr-korpa-9XngoIpxcEo-unsplash.jpg".source =
      ./wallpapers/jr-korpa-9XngoIpxcEo-unsplash.jpg;
    xdg.configFile."hypr/wallpapers/salty-justice-NOMebOREvtc-unsplash.jpg".source =
      ./wallpapers/salty-justice-NOMebOREvtc-unsplash.jpg;
  };
}
