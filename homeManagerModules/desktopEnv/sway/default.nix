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
    guiApps.kanshi.enable = lib.mkDefault true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      # brightnessctl
      # hyprnome
      celluloid
      evince
      gnome.eog
      gnome.file-roller
      kdePackages.polkit-kde-agent-1
      networkmanagerapplet
      playerctl
      swayosd
      trayscale
      xfce.exo
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfce4-settings
      xfce.xfce4-taskmanager
      xfce.xfconf
      swayidle
    ];

    programs.swaylock.enable = lib.mkDefault true;

    services.cliphist.enable = lib.mkDefault true;

    wayland.windowManager.sway.enable = true;
    wayland.windowManager.sway.config = {
      bars = [{command = "${pkgs.waybar}/bin/waybar";}];
      # bars.waybar.command = "${pkgs.waybar}/bin/waybar";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      modifier = "Mod4";
      colors.focused = {
        background = "#ca9ee6";
        border = "#ca9ee6";
        childBorder = "#ca9ee6";
        indicator = "#ca9ee6";
        text = "#ffffff";
      };
      colors.focusedInactive = {
        background = "#99d1db";
        border = "#99d1db";
        childBorder = "#99d1db";
        indicator = "#99d1db";
        text = "#ffffff";
      };
      colors.unfocused = {
        background = "#99d1db";
        border = "#99d1db";
        childBorder = "#99d1db";
        indicator = "#99d1db";
        text = "#ffffff";
      };
      gaps.inner = 5;
      gaps.outer = 10;
      window.titlebar = false;
      fonts = {
        names = ["Noto SansM Nerd Font"];
        style = "Bold";
        size = 12.0;
      };
      startup = [
        # { command = "${pkgs.kanshi}"; }
        {command = "nm-applet";}
        {command = "swayosd-server";}
        {command = "thunar --daemon";}
        {command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock' before-sleep '${pkgs.swaylock}/bin/swaylock'";}
      ];
      output = {
        "BOE 0x095F Unknown" = {
          scale = "1.5";
        };
      };
      input = {
        "type:touchpad" = {
          click_method = "clickfinger";
          dwt = "enabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };
    };

    wayland.windowManager.sway.extraConfig = ''
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next
    '';

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
