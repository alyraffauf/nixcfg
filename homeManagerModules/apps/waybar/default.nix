{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.waybar.enable = lib.mkEnableOption "Enables waybar.";};

  config = lib.mkIf config.alyraffauf.apps.waybar.enable {
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      blueberry
      pavucontrol
      (nerdfonts.override {fonts = ["Noto"];})
    ];

    xdg.configFile."waybar/style.css".source = ./waybar.css;

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 36;
          layer = "top";
          output = ["*"];
          position = "top";
          modules-left = lib.mkDefault [];
          modules-center = ["clock"];
          modules-right = [
            "tray"
            "group/hardware"
          ];
          "hyprland/workspaces" = {
            "all-outputs" = true;
            "format" = "{icon} {name}";
            "format-icons" = {
              "default" = "󰝥";
              "active" = "󰪥";
            };
            "sort-by" = "id";
          };
          "hyprland/submap" = {
            "on-click" = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch submap reset";
          };
          "hyprland/window" = {
            "format" = "";
            "max-length" = 100;
            "separate-outputs" = true;
            "icon" = true;
          };
          "sway/workspaces" = {
            "all-outputs" = true;
            "format" = "{icon} {name}";
            "format-icons" = {
              "default" = "󰝥";
              "focused" = "󰪥";
            };
            "sort-by" = "id";
          };
          "sway/mode" = {
            "on-click" = "${config.wayland.windowManager.sway.package}/bin/swaymsg mode default";
          };
          "sway/window" = {
            "max-length" = 100;
          };
          "river/window" = {
            "max-length" = 100;
          };
          "river/tags" = {
            "num-tags" = 4;
          };
          "clock" = {
            "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
            "interval" = 60;
            "format" = "{:%I:%M%p}";
          };
          "battery" = {
            "states" = {"critical" = 20;};
            "format" = "{icon}";
            "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            "tooltip-format" = ''
              {capacity}%: {timeTo}.
              Draw: {power} watts.'';
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
            "format" = "󰂯";
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
              "default" = ["" "" ""];
            };
            "scroll-step" = 5;
            "ignored-sinks" = ["Easy Effects Sink"];
            "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol -t 3";
          };
          "network" = {
            "format-wifi" = "{icon}";
            "format-ethernet" = "󰈀";
            "format-disconnected" = "⚠";
            "format-icons" = ["󰤟" "󰤢" "󰤥" "󰤨"];
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
          "group/hardware" = {
            "orientation" = "horizontal";
            modules = ["bluetooth" "pulseaudio" "power-profiles-daemon" "battery" "custom/logout"];
          };
        };
      };
    };
  };
}
