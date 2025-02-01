{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.myHome.desktop.hyprland.enable) {
    myHome = {
      programs = {
        rofi.enable = lib.mkDefault true;
        wezterm.enable = lib.mkDefault true;
      };

      services = {
        hypridle.enable = lib.mkDefault config.myHome.desktop.hyprland.enable;
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

    # qt = lib.mkIf (!config.myHome.desktop.kde.enable) {
    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "Breeze";
    };

    services = {
      batsignal = {
        enable = true;

        extraArgs = [
          "-D ${pkgs.systemd}/bin/systemctl suspend"
          "-e"
          "-i"
          "-m 7"
          "-p"
        ];
      };

      gnome-keyring.enable = true;
      playerctld.enable = lib.mkDefault true;
    };

    stylix = {
      iconTheme = {
        enable = true;
        dark = "Papirus-Dark";
        light = "Papirus";
        package = pkgs.papirus-icon-theme.override {color = "adwaita";};
      };

      targets.gtk.extraCss = builtins.concatStringsSep "\n" [
        (lib.optionalString (config.stylix.polarity == "light")
          ''
            tooltip {
              &.background { background-color: alpha(${config.lib.stylix.colors.withHashtag.base05}, ${builtins.toString config.stylix.opacity.popups}); }
              background-color: alpha(${config.lib.stylix.colors.withHashtag.base05}, ${builtins.toString config.stylix.opacity.popups});
            }'')
      ];
    };

    systemd.user.services.polkit-gnome-authentication-agent = {
      Unit = {
        After = "graphical-session.target";
        BindsTo = lib.optional (config.myHome.desktop.hyprland.enable) "hyprland-session.target";
        Description = "PolicyKit authentication agent from GNOME.";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "no";
      };

      Install.WantedBy = lib.optional (config.myHome.desktop.hyprland.enable) "hyprland-session.target";
    };

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
