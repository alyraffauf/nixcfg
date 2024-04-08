{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktopEnv.sway.enable = lib.mkEnableOption "Sway with extra apps.";
  };

  config = lib.mkIf config.desktopEnv.sway.enable {
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

    wayland.windowManager.sway.enable = true;
    wayland.windowManager.sway.config = {
      bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];
      # bars.waybar.command = "${pkgs.waybar}/bin/waybar";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      modifier = "Mod4";
    };

    xdg.configFile."xfce4/helpers.rc".text = ''
      TerminalEmulator=alacritty
      FileManager=thunar
      WebBrowser=firefox
    '';

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-wlr];
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };
  };
}
