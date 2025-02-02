{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  cfg = config.myHome;
in {
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

    windowManagerBinds = lib.mkOption {
      description = "Default binds for window management.";

      default = {
        Down = "down";
        Left = "left";
        Right = "right";
        Up = "up";
        H = "left";
        J = "down";
        K = "up";
        L = "right";
      };

      type = lib.types.attrs;
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

      extraConfig = let
        moveMonitorBinds =
          lib.attrsets.mapAttrsToList (
            key: direction: "bind=CONTROL,${key},movecurrentworkspacetomonitor,${builtins.substring 0 1 direction}"
          )
          cfg.desktop.hyprland.windowManagerBinds;

        moveWindowBinds =
          lib.attrsets.mapAttrsToList (
            key: direction: "bind=,${key},movewindow,${builtins.substring 0 1 direction}"
          )
          cfg.desktop.hyprland.windowManagerBinds;

        moveWorkspaceBinds = builtins.map (x: "bind=,${toString x},workspace,${toString x}") [1 2 3 4 5 6 7 8 9];
      in ''
        submap=resize
        binde=,down,resizeactive,0 10
        binde=,left,resizeactive,-10 0
        binde=,right,resizeactive,10 0
        binde=,up,resizeactive,0 -10
        binde=,j,resizeactive,0 10
        binde=,h,resizeactive,-10 0
        binde=,l,resizeactive,10 0
        binde=,k,resizeactive,0 -10
        bind=,escape,submap,reset
        submap=reset

        submap=move
        ${lib.strings.concatLines moveMonitorBinds}
        ${lib.strings.concatLines moveWindowBinds}
        ${lib.strings.concatLines moveWorkspaceBinds}
        bind=,comma,exec,${lib.getExe pkgs.hyprnome} --previous --move
        bind=,period,exec,${lib.getExe pkgs.hyprnome} --move
        bind=,escape,submap,reset
        submap=reset
      '';
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
