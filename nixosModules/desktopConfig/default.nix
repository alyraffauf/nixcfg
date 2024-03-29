{ pkgs, lib, config, ... }: {

  imports =
    [ ./displayManagers/lightdm ./gnome ./plasma ./windowManagers/hyprland ];

  options = {
    desktopConfig.enable =
      lib.mkEnableOption "Enables basic GUI X11 and Wayland environment.";
  };

  config = lib.mkIf config.desktopConfig.enable {
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      excludePackages = with pkgs; [ xterm ];
    };

    # Install pretty fonts.
    fonts.packages = with pkgs;
      [
        liberation_ttf
        (nerdfonts.override {
          fonts = [
            "DroidSansMono"
            "FiraCode"
            "FiraMono"
            "Hack"
            "Noto"
          ];
        })
      ];

    # Enable basic assortment of GUI apps.
    environment.systemPackages = with pkgs; [
      fractal
      github-desktop
      obsidian
      tauon
      webcord
      zoom-us
    ];

    desktopConfig.windowManagers.hyprland.enable = lib.mkDefault true;
  };
}
