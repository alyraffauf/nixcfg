{ pkgs, lib, config, ... }: {

  imports = [ ./displayManagers/lightdm ./gnome ./plasma ./windowManagers/hyprland ];

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
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" "DroidSansMono" "Noto" ]; })
      fira-code
      fira-code-symbols
      liberation_ttf
    ];

    # Enable basic assortment of GUI apps.
    environment.systemPackages = with pkgs; [
      firefox
      fractal
      github-desktop
      google-chrome
      obsidian
      tauon
      vscode
      webcord
      zoom-us
    ];

    desktopConfig.windowManagers.hyprland.enable = lib.mkDefault true;
  };
}
