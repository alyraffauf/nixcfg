{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [ blueberry pavucontrol ];

  xdg.configFile."waybar/style.css".source = ./waybar.css;

  programs.waybar.enable = true;
  programs.waybar.settings = {
    mainBar = {
      height = 36;
      layer = "top";
      output = [ "*" ];
      position = "top";
      reload_style_on_change = true;
      modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "tray"
        "bluetooth"
        "network"
        "pulseaudio"
        "battery"
        "power-profiles-daemon"
        "clock"
      ];

      "hyprland/workspaces" = {
        "all-outputs" = true;
        "format" = "󰧞";
      };
      "hyprland/window" = { "max-length" = 100; };
      "clock" = {
        "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
        "interval" = 60;
        "format" = "{:%I:%M%p}";
      };
      "battery" = {
        "states" = { "critical" = 20; };
        "format" = "{icon}";
        "format-icons" = [ "󰁺" "󰁼" "󰁿" "󰂁" "󰁹" ];
        "tooltip-format" = ''
          {capacity}%: {timeTo}.
          Using {power} watts.'';
      };
      "bluetooth" = {
        "format" = "󰂯　{status}";
        "format-disabled" = ""; # an empty format will hide the module
        "format-connected" = "󰂯　{num_connections} connected";
        "tooltip-format" = "{controller_alias}	{controller_address}";
        "tooltip-format-connected" = ''
          {controller_alias}	{controller_address}

          {device_enumerate}'';
        "tooltip-format-enumerate-connected" =
          "{device_alias}	{device_address}";
        "on-click" = "blueberry";
      };
      "pulseaudio" = {
        "format" = "　{volume}%";
        "format-bluetooth" = "{volume}% {icon}󰂯";
        "format-muted" = "";
        "format-icons" = {
          "headphones" = "󰋋";
          "handsfree" = "󰋎";
          "headset" = "󰋎";
        };
        "on-click" = "pavucontrol -t 3";
      };
      "network" = {
        "format-wifi" = "󰣾　{signalStrength}%";
        "format-ethernet" = "󰈀";
        "format-disconnected" = "⚠";
        "tooltip-format" = "{ifname} via {gwaddr} 󰊗";
        "tooltip-format-wifi" = "{essid} ({signalStrength}%) 󰣾";
        "tooltip-format-ethernet" = "{ifname} ";
        "tooltip-format-disconnected" = "Disconnected";
        "on-click" = "alacritty --class nmtui -e nmtui";
      };
      "tray" = { "spacing" = 10; };
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
}
