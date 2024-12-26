{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.ar.home.desktop.hyprland.enable) {
    ar.home = {
      apps = {
        kitty.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
      };

      services = {
        hypridle.enable = lib.mkDefault config.ar.home.desktop.hyprland.enable;
        mako.enable = lib.mkDefault true;
        pipewire-inhibit.enable = lib.mkDefault true;
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
        rounding = config.ar.home.theme.borders.radius;
      };

      label = [
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 40;
          halign = "center";
          position = "0, 400";
          shadow_passes = 2;
          text = "Hi, $DESC.";
          valign = "center";
        }
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 40;
          halign = "center";
          position = "0, 100";
          shadow_passes = 2;
          text = "$TIME12";
          valign = "bottom";
        }
        {
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 24;
          halign = "center";
          position = "0, -200";
          shadow_passes = 2;
          text = "$FPRINTMESSAGE";
          valign = "center";
        }
      ];
    };

    services.playerctld.enable = lib.mkDefault true;

    xdg.portal = {
      enable = true;
      configPackages =
        lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
      extraPortals =
        [pkgs.xdg-desktop-portal-gtk]
        ++ lib.optional (config.ar.home.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
