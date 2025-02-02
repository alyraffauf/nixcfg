{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeManagerModules.desktop
    self.homeManagerModules.programs-rofi
    self.homeManagerModules.programs-wezterm
    self.homeManagerModules.services-hypridle
    self.homeManagerModules.services-mako
    self.homeManagerModules.services-swayosd
    self.homeManagerModules.services-waybar
  ];

  options.myHome.desktop.hyprland = {
    laptopMonitor = lib.mkOption {
      description = "Internal laptop monitor.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    monitors = lib.mkOption {
      description = "List of external monitors.";

      default = [
        "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-1920x0,2.0"
        "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
        "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
      ];

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

  config = {
    home.packages = with pkgs; [
      blueberry
      file-roller
      libnotify
      networkmanagerapplet
    ];

    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "Breeze";
    };

    dconf.settings = {
      "org/gnome/desktop/wm/preferences".button-layout = "";

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
  };
}
