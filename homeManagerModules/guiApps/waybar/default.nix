{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {guiApps.waybar.enable = lib.mkEnableOption "Enables waybar.";};

  config = lib.mkIf config.guiApps.waybar.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      blueberry
      pavucontrol
      (nerdfonts.override {fonts = ["Noto"];})
    ];

    xdg.configFile."waybar/style.css".source = ./waybar.css;

    programs.waybar.enable = true;
    programs.waybar.settings = {
      mainBar = {
        height = 36;
        layer = "top";
        output = ["*"];
        position = "top";
        reload_style_on_change = true;
        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["hyprland/window"];
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "pulseaudio"
          # "wireplumber"
          "group/power"
          "custom/logout"
          "clock"
        ];

        "hyprland/workspaces" = {
          "all-outputs" = true;
          "format" = "{icon}";
          "format-icons" = {
            "default" = "󰝥";
            "active" = "󰪥";
          };
          "persistent-workspaces" = {"*" = 4;};
        };
        "hyprland/window" = {
          "max-length" = 100;
          "separate-outputs" = true;
        };
        "clock" = {
          # "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
          "interval" = 60;
          "format" = "{:%I:%M%p}";
        };
        "group/power" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "children-class" = "not-power";
            "transition-left-to-right" = false;
          };
          "modules" = [
            "battery"
            "power-profiles-daemon"
            "inhibitor"
          ];
        };
        "battery" = {
          "states" = {"critical" = 20;};
          "format" = "{icon}";
          "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          "tooltip-format" = ''
            {capacity}%: {timeTo}.
            Using {power} watts.'';
        };
        "inhibitor" = {
          "what" = "sleep";
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "bluetooth" = {
          "format" = "󰂯　{status}";
          "format-disabled" = ""; # an empty format will hide the module
          "format-connected" = "󰂯　{num_connections} connected";
          "tooltip-format" = "{controller_alias}	{controller_address}";
          "tooltip-format-connected" = ''
            {controller_alias}	{controller_address}

            {device_enumerate}'';
          "tooltip-format-enumerate-connected" = "{device_alias}	{device_address}";
          "on-click" = "${pkgs.blueberry}/bin/blueberry";
        };
        "pulseaudio" = {
          "format" = "{icon}";
          "format-bluetooth" = "{volume}% {icon}󰂯";
          "format-muted" = "";
          "format-icons" = {
            "headphones" = "󰋋";
            "handsfree" = "󰋎";
            "headset" = "󰋎";
            "default" = [ "" "" "" ];
          };
          "scroll-step" = 5;
          "ignored-sinks" = ["Easy Effects Sink"];
          "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol -t 3";
        };
        "network" = {
          "format-wifi" = "{icon}";
          "format-ethernet" = "󰈀";
          "format-disconnected" = "⚠";
          "format-icons" = ["󰤟" "󰤢" "󰤥" "󰤨" ];
          "tooltip-format" = "{ifname} via {gwaddr} 󰊗";
          "tooltip-format-wifi" = "{essid} ({signalStrength}%) {icon}";
          "tooltip-format-ethernet" = "{ifname} ";
          "tooltip-format-disconnected" = "Disconnected";
          "on-click" = "${pkgs.alacritty}/bin/alacritty --class nmtui -e ${pkgs.networkmanager}/bin/nmtui";
        };
        "tray" = {"spacing" = 15;};
        "custom/logout" = {
          "on-click" = "${pkgs.wlogout}/bin/wlogout";
          "format" = "󰗽";
        };
        "power-profiles-daemon" = {
          "format" = "{icon}";
          "tooltip-format" = ''
            Profile: {profile}
            Driver: {driver}'';
          "tooltip" = true;
          "format-icons" = {
            "default" = "󱐌";
            "performance" = "󱐌";
            "balanced" = "󰗑";
            "power-saver" = "󰌪";
          };
        };
      };
    };
  };
}
