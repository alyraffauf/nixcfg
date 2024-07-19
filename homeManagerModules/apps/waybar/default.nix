{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.waybar.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 32;
          layer = "top";
          output = ["*"];
          position = "top";
          modules-left =
            lib.optionals (config.ar.home.desktop.hyprland.enable)
            ["hyprland/workspaces" "hyprland/submap"]
            ++ lib.optionals (config.ar.home.desktop.sway.enable)
            ["sway/workspaces" "sway/scratchpad" "sway/mode"]
            ++ lib.optionals (config.ar.home.desktop.hyprland.tabletMode.menuButton)
            ["custom/menu" "custom/hyprland-close"];

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
            "on-click" = ''${lib.getExe'
                config.wayland.windowManager.hyprland.package "hyprctl"} dispatch submap reset'';
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
            "on-click" = ''${lib.getExe' config.wayland.windowManager.sway.package "swaymsg"} mode default'';
          };

          "sway/window" = {
            "max-length" = 100;
          };

          "sway/scratchpad" = {
            "format" = "{icon}　{count}";
            "show-empty" = false;
            "format-icons" = ["" ""];
            "tooltip" = true;
            "tooltip-format" = "{app}: {title}";
          };

          "custom/sway-close" = {
            "on-click" = ''${lib.getExe'
                config.wayland.windowManager.sway.package "swaymsg"} kill'';
            "format" = "󰅗";
          };

          "custom/hyprland-close" = {
            "on-click" = ''${lib.getExe'
                config.wayland.windowManager.hyprland.package "hyprctl"} dispatch killactive'';
            "format" = "󰅗";
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
            "on-click" = lib.getExe' pkgs.blueberry "blueberry";
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
            "on-click" = "${lib.getExe pkgs.pavucontrol} -t 3";
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
            "on-click" = "${lib.getExe config.ar.home.defaultApps.terminalEditor} --class nmtui -e ${pkgs.networkmanager}/bin/nmtui";
          };

          "tray" = {"spacing" = 15;};

          "custom/logout" = {
            "on-click" = "${lib.getExe pkgs.wlogout}";
            "format" = "󰗽";
          };

          "custom/menu" = {
            "on-click" = "${lib.getExe pkgs.nwg-drawer} -mt 5";
            "format" = "󰀻";
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
            modules = ["pulseaudio" "power-profiles-daemon" "battery" "custom/logout"];
          };
        };
      };
    };

    xdg.configFile."waybar/style.css".text = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "NotoSansM Nerd Font";
        font-size: 14px;
        font-weight: 600;
      }

      window#waybar {
        background: rgba (35, 38, 52, 0.0);
        color: ${config.ar.home.theme.colors.text};
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 0 0px;
        color: ${config.ar.home.theme.colors.text};
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: ${config.ar.home.theme.colors.primary};
      }

      #submap,
      #mode {
        padding: 0 15px;
        margin: 0 5px;
        color: #FFFFFF;
      }

      #tags button {
        padding: 0px 5px;
        margin: 0 0px;
        color: ${config.ar.home.theme.colors.text};
      }

      #tags button.focused {
        color: ${config.ar.home.theme.colors.primary};
      }

      #clock,
      #battery,
      #bluetooth,
      #network,
      #power-profiles-daemon,
      #pulseaudio,
      #wireplumber,
      #inhibitor,
      #custom-logout,
      #custom-menu,
      #custom-sway-close,
      #tray {
        padding: 0 7.5px;
        margin: 0 5px;
      }

      #battery {
          color: ${config.ar.home.theme.colors.text};
      }

      #battery.charging {
          color: ${config.ar.home.theme.colors.primary};
      }

      #battery.critical:not(.charging) {
          color: #e78284;
      }

      #workspaces,
      #mode,
      #submap,
      #scratchpad,
      #tray,
      #clock,
      #custom-menu,
      #custom-sway-close,
      #custom-hyprland-close,
      #hardware {
          border-radius: 10;
          background: rgba (36, 36, 36, 0.8);
          margin: 5px 10px 0px 10px;
          padding: 0px 10px 0px 10px;
      }

      #clock, #custom-menu, #custom-sway-close, #custom-hyprland-close {
          padding: 0px 20px 0px 20px;
      }

      #submap,
      #mode {
          color: ${config.ar.home.theme.colors.text};
          background: rgba(255, 123, 99, 0.8);
      }
    '';
  };
}
