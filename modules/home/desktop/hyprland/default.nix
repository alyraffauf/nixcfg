{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland desktop environment";

    laptopMonitor = lib.mkOption {
      description = "Internal laptop monitor.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    monitors = lib.mkOption {
      description = "List of external monitors.";
      default = [];
      type = lib.types.listOf lib.types.str;
    };

    tabletMode = {
      enable = lib.mkEnableOption "Tablet mode for hyprland.";

      switches = lib.mkOption {
        description = "Switches to activate tablet mode when toggled.";
        default = [];
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config = lib.mkIf config.myHome.desktop.hyprland.enable {
    home.packages = with pkgs; [
      blueberry
      file-roller
      libnotify
      nemo
      networkmanagerapplet
    ];

    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "Breeze";
    };

    dconf.settings = {
      "org/gnome/desktop/wm/preferences".button-layout = "";

      "org/nemo/preferences" = {
        show-image-thumbnails = "always";
        thumbnail-limit = lib.hm.gvariant.mkUint64 (100 * 1024 * 1024);
        tooltips-in-icon-view = true;
        tooltips-show-access-date = true;
        tooltips-show-birth-date = true;
        tooltips-show-file-type = true;
        tooltips-show-mod-date = true;
      };

      "org/nemo/preferences/menu-config" = {
        background-menu-open-as-root = false;
        selection-menu-open-as-root = false;
      };

      "org/nemo/plugins".disabled-actions = [
        "90_new-launcher.nemo_action"
        "add-desklets.nemo_action"
        "change-background.nemo_action"
        "mount-archive.nemo_action"
        "set-as-background.nemo_action"
        "set-resolution.nemo_action"
      ];
    };

    programs.wezterm = {
      enable = true;

      extraConfig = ''
        return {
          hide_tab_bar_if_only_one_tab = true
        }
      '';
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
        BindsTo = ["hyprland-session.target"];
        Description = "PolicyKit authentication agent from GNOME.";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "no";
      };

      Install.WantedBy = ["hyprland-session.target"];
    };

    wayland.windowManager.hyprland = {
      enable = true;

      # plugins = [
      #   pkgs.hyprlandPlugins.hyprspace
      # ];

      settings = import ./settings.nix {inherit config lib pkgs;};

      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-hyprland];

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    myHome = {
      desktop.enable = true;
      programs.rofi.enable = true;

      services = {
        hypridle.enable = true;
        mako.enable = true;
        swayosd.enable = true;
        waybar.enable = true;
      };
    };
  };
}
