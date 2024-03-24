{ config, pkgs, ... }:

{
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      bemenu
      brightnessctl
      hyprcursor
      hypridle
      hyprlock
      hyprpaper
      hyprshade
      hyprshot
      mako
      overskride
      pavucontrol
      playerctl
      udiskie
    ];

    services.mako = {
      enable = true;
      font = "DroidSansM Nerd Font Mono 11";
      backgroundColor = "#000000";
      textColor = "#FFFFFF";
      borderRadius = 10;
      defaultTimeout = 10000;
      padding = "15";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./dotfiles/hyprland.conf;
    };

    xdg.configFile."hypr/hypridle.conf".source = ./dotfiles/hypridle.conf;
    xdg.configFile."hypr/hyprlock.conf".source = ./dotfiles/hyprlock.conf;

    programs.waybar.enable = true;
    programs.waybar.style = ''
      * {
         border: none;
         border-radius: 0;
         font-family: DroidSansM Nerd Font Mono;
      }
      window#waybar {
         background: #000;
         color: #FFFFFF;
      }
      #workspaces button {
         padding: 5px 10px;
         background: #000;
         color: #FFFFFF;
      }
      #clock, #battery, #pulseaudio, #bluetooth, #network, #tray {
        padding: 0 10px;
        margin: 0 5px;
      }
    '';
    programs.waybar.settings = {
        mainBar = {
            layer = "top";
            position = "top";
            height = 36;
            output = [
                "eDP-1"
                "HDMI-A-1"
            ];
            modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
            modules-center = [ "hyprland/window" ];
            modules-right = [ "tray" "bluetooth" "network" "pulseaudio" "battery" "clock"];

            "hyprland/workspaces" = {
                all-outputs = true;
            };
            "hyprland/window" = {
                "max-length" = 150;
            };
            "clock" = {
                "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
                "interval" = 60;
                "format" = "󰅐　{:%I:%M%p}";
            };
            "battery" = {
                "format" = "󰂎　{capacity}%";
                "on-click" = "pp-adjuster";
            };
            "bluetooth" = {
                "format" = "󰂯　{status}";
                "format-disabled" = ""; # an empty format will hide the module
                "format-connected" = "󰂯　{num_connections} connected";
                "tooltip-format" = "{controller_alias}\t{controller_address}";
                "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
                "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
                "on-click" = "overskride";
            };
            "pulseaudio" = {
                "format" = "　{volume}%";
                 "format-bluetooth" = "{volume}% {icon}󰂯";
                 "format-muted" = "";
                 "format-icons"=  {
                     "headphones" = "󰋋";
                     "handsfree" = "󰋎";
                     "headset" = "󰋎";
                 };
                "on-click" = "pavucontrol";
            };
            "network" = {
                "format-wifi" = "󰣾　{signalStrength}%";
                "format-disconnected" = "⚠";
                "tooltip-format" = "{ifname} via {gwaddr} 󰊗";
                "tooltip-format-wifi" = "{essid} ({signalStrength}%) 󰣾";
                "tooltip-format-ethernet" = "{ifname} ";
                "tooltip-format-disconnected" = "Disconnected";
                "on-click" = "alacritty -e nmtui";
            };
        };
    };
}
