{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland with full desktop session components.";

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

  config = lib.mkIf cfg.desktop.hyprland.enable {
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
          cfg.desktop.windowManagerBinds;

        moveWindowBinds =
          lib.attrsets.mapAttrsToList (
            key: direction: "bind=,${key},movewindow,${builtins.substring 0 1 direction}"
          )
          cfg.desktop.windowManagerBinds;

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
      configPackages =
        lib.optional (config.myHome.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
      extraPortals =
        [pkgs.xdg-desktop-portal-gtk]
        ++ lib.optional (config.myHome.desktop.hyprland.enable) pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
