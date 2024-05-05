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
    ];

    xdg.configFile."waybar/style.css".text = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "${lib.strings.removeSuffix "-Regular" config.alyraffauf.desktop.theme.terminalFont.name}";
          font-size: 14px;
          font-weight: 600;
      }

      window#waybar {
          background: rgba (35, 38, 52, 0.0);
          color: ${config.alyraffauf.desktop.theme.colors.text};
      }

      #workspaces button {
          padding: 0px 5px;
          margin: 0 0px;
          color: ${config.alyraffauf.desktop.theme.colors.text};
      }

      #workspaces button.active,
      #workspaces button.focused {
          color: ${config.alyraffauf.desktop.theme.colors.primary};
      }

      #submap,
      #mode {
          padding: 0 15px;
          margin: 0 5px;
          color: #e78284;
      }

      #tags button {
          padding: 0px 5px;
          margin: 0 0px;
          color: ${config.alyraffauf.desktop.theme.colors.text};
      }

      #tags button.focused {
          color: ${config.alyraffauf.desktop.theme.colors.primary};
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
      #tray {
          padding: 0 7.5px;
          margin: 0 5px;
      }

      #battery {
          color: ${config.alyraffauf.desktop.theme.colors.text};
      }

      #battery.charging {
          color: ${config.alyraffauf.desktop.theme.colors.primary};
      }

      #battery.critical:not(.charging) {
          color: #e78284;
      }

      #workspaces,
      #mode,
      #submap,
      #tray,
      #clock,
      #hardware {
          border-radius: 10;
          background: rgba (35, 38, 52, 0.8);
          margin: 5px 10px 0px 10px;
          padding: 0px 10px 0px 10px;
      }

      #clock {
          padding: 0px 20px 0px 20px;
      }

      #submap,
      #mode {
          color: ${config.alyraffauf.desktop.theme.colors.text};
          background: rgba(231, 130, 132, 0.8);
      }
    '';

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 32;
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
