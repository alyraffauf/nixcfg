{ pkgs, lib, config, ... }: {

  options = {
    desktopEnv.hyprland.hypridle.enable =
      lib.mkEnableOption "Enables hypridle.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.hypridle.enable {

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [ hypridle ];

    xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
  };
}
