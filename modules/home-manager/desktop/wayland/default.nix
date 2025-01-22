{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.myHome.desktop.hyprland.enable) {
    myHome = {
      apps = {
        kitty.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
      };

      services = {
        hypridle.enable = lib.mkDefault config.myHome.desktop.hyprland.enable;
        mako.enable = lib.mkDefault true;
        swayosd.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
      };
    };

    home.packages = with pkgs; [
      blueberry
      file-roller
      libnotify
      networkmanagerapplet
    ];

    programs.hyprlock.settings = {
      auth.fingerprint = {
        enabled = true;
        present_message = "Scanning fingerprint...";
        ready_message = "Scan fingerprint to unlock.";
      };

      input-field = {
        font_family = config.stylix.fonts.sansSerif.name;
        rounding = config.myHome.theme.borders.radius;
      };

      shape = [
        {
          border_color = "rgb(${config.lib.stylix.colors.base0D})";
          border_size = 8;
          color = "rgb(${config.lib.stylix.colors.base00})";
          halign = "center";
          position = "-33%, 0";
          rotate = 0;
          rounding = config.myHome.theme.borders.radius;
          shadow_color = "rgb(${config.lib.stylix.colors.base01})";
          shadow_passes = 3;
          size = "600, 600";
          valign = "center";
          xray = false;
        }
      ];

      label = [
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 40;
          halign = "center";
          position = "-33%, 200";
          shadow_passes = 0;
          text = "Hi $DESC 👋";
          valign = "center";
        }
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 40;
          halign = "center";
          position = "-33%, -200";
          shadow_passe = 0;
          text = "It is $TIME12.";
          valign = "center";
        }
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 24;
          halign = "center";
          position = "-33%, 0";
          shadow_passes = 0;
          text = "$FPRINTMESSAGE";
          valign = "center";
        }
      ];
    };

    services.playerctld.enable = lib.mkDefault true;

    xdg.portal = {
      enable = true;
      configPackages =
        lib.optional (config.myHome.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
      extraPortals =
        [pkgs.xdg-desktop-portal-gtk]
        ++ lib.optional (config.myHome.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
