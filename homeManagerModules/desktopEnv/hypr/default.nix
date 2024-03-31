{ pkgs, lib, config, ... }: {

  imports = [ ./hypridle ./hyprlock ./hyprpaper ./hyprshade ./theme.nix ];

  options = {
    desktopEnv.hyprland.enable =
      lib.mkEnableOption "Enables hyprland with extra apps.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.enable {

    # Hypr* modules, plguins, and tools.
    desktopEnv.hyprland.hypridle.enable = lib.mkDefault true;
    desktopEnv.hyprland.hyprlock.enable = lib.mkDefault true;
    desktopEnv.hyprland.hyprpaper.enable = lib.mkDefault true;
    desktopEnv.hyprland.hyprshade.enable = lib.mkDefault true;

    desktopEnv.hyprland.gtk-qt.enable = lib.mkDefault true;

    # Basic apps needed to run a hyprland desktop.
    guiApps.waybar.enable = lib.mkDefault true;
    guiApps.mako.enable = lib.mkDefault true;
    guiApps.fuzzel.enable = lib.mkDefault true;
    guiApps.wlogout.enable = lib.mkDefault true;
    guiApps.alacritty.enable = lib.mkDefault true;
    guiApps.firefox.enable = lib.mkDefault true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      brightnessctl
      evince
      hyprcursor
      hyprland-protocols
      hyprnome
      hyprshot
      playerctl
      xfce.exo
      xfce.ristretto
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfce4-settings
      xfce.xfce4-taskmanager
      xfce.xfconf
    ];

    services.cliphist.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };

    xdg.configFile."xfce4/helpers.rc".text = ''
      TerminalEmulator=alacritty
      FileManager=thunar
      WebBrowser=firefox
    '';

    xdg.portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
  };
}
