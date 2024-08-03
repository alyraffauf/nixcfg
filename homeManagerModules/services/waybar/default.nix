{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.services.waybar.enable {
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
            ++ lib.optionals (config.ar.home.desktop.hyprland.tabletMode.enable)
            ["custom/menu" "custom/hyprland-close"];

          modules-center = ["clock"];
          modules-right = [
            "tray"
            "group/hardware"
            "group/session"
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

          "sway/scratchpad" = {
            "format" = "{icon}　{count}";
            "format-icons" = ["" ""];
            "show-empty" = false;
            "tooltip" = true;
            "tooltip-format" = "{app}: {title}";
          };

          "custom/hyprland-close" = {
            "on-click" = ''${lib.getExe'
                config.wayland.windowManager.hyprland.package "hyprctl"} dispatch killactive'';
            "format" = "󰅗";
            "tooltip-format" = "Close the focused window.";
          };

          "clock" = {
            "format" = "{:%I:%M%p}";
            "interval" = 60;
            "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
          };

          "battery" = let
            checkBattery = pkgs.writeShellScript "check-battery" ''
              bat=/sys/class/power_supply/BAT0
              CRIT=''${1:-10}
              NOTIFY=${lib.getExe' pkgs.libnotify "notify-send"}

              stat=$(cat $bat/status)
              perc=$(cat $bat/capacity)

              if [[ $perc -le $CRIT ]] && [[ $stat == "Discharging" ]]; then
                $NOTIFY --urgency=critical --icon=dialog-error "Battery Critical" "Current charge: $perc%".
              fi
            '';
          in {
            "format" = "{icon}";
            "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];

            "on-update" = "${checkBattery}";
            "tooltip-format" = ''
              {capacity}%: {timeTo}.
              Draw: {power} watts.'';

            "states" = {"critical" = 20;};
          };

          "idle_inhibitor" = {
            "format" = "{icon}";

            "format-icons" = {
              "activated" = "󰅶";
              "deactivated" = "󰾪";
            };

            "timeout" = 45;

            "tooltip-format-activated" = ''
              Presentation mode enabled.
              System will not sleep.'';

            "tooltip-format-deactivated" = ''
              Presentation mode disabled.
              System will sleep normally.'';
          };

          "bluetooth" = {
            "format" = "";
            "format-connected" = "　{num_connections}";
            "format-disabled" = ""; # an empty format will hide the module
            "on-click" = lib.getExe' pkgs.blueberry "blueberry";
            "tooltip-format" = "{controller_alias}	{controller_address}";

            "tooltip-format-connected" = ''
              {controller_alias}	{controller_address}

              {device_enumerate}'';

            "tooltip-format-enumerate-connected" = "{device_alias}	{device_address}";
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

            "ignored-sinks" = ["Easy Effects Sink"];
            "on-click" = "${lib.getExe pkgs.pavucontrol} -t 3";
            "scroll-step" = 5;
          };

          "network" = {
            "format-disabled" = "󰀝";
            "format-disconnected" = "󰀦";
            "format-ethernet" = "󰈀";
            "format-icons" = ["󰤟" "󰤢" "󰤥" "󰤨"];
            "format-wifi" = "{icon}";
            "on-click" = "${lib.getExe pkgs.networkmanager_dmenu} -i";
            "tooltip-format" = "{ifname} via {gwaddr} 󰊗";
            "tooltip-format-disconnected" = "Disconnected";
            "tooltip-format-ethernet" = "{ifname} ";
            "tooltip-format-wifi" = "{essid} ({signalStrength}%) {icon}";
          };

          "tray" = {"spacing" = 15;};

          "custom/dnd" = let
            mako-dnd = pkgs.writeShellScript "mako-dnd" ''
              show() {
                  MAKO_MODE=$(${lib.getExe' pkgs.mako "makoctl"} mode)
                  if echo "$MAKO_MODE" | grep -q "do-not-disturb"; then
                      printf '{"text": "󰂛", "class": "on", "tooltip": "Notifications snoozed."}\n'
                  else
                      printf '{"text": "󰂚", "class": "off","tooltip": "Notifications enabled."}\n'
                  fi
              }

              toggle() {
                  ${lib.getExe' pkgs.mako "makoctl"} mode -t do-not-disturb
                  ${lib.getExe' pkgs.procps "pkill"} -SIGRTMIN+2 .waybar-wrapped
              }

              [ $# -gt 0 ] && toggle || show
            '';
          in {
            "exec" = "${mako-dnd}";
            "interval" = "once";
            "on-click" = "${mako-dnd} toggle";
            "return-type" = "json";
            "signal" = 2;
          };

          "custom/logout" = {
            "format" = "󰤆";
            "on-click" = ''${lib.getExe config.programs.rofi.package} -i -show power-menu -modi "power-menu:${lib.getExe pkgs.rofi-power-menu} --choices=logout/lockscreen/suspend/shutdown/reboot"'';
            "tooltip-format" = "Manage your session.";
          };

          "custom/menu" = {
            "format" = "󰀻";
            "on-click" = "${lib.getExe pkgs.nwg-drawer} -mt 5";
            "tooltip-format" = "Touch-friendly application menu.";
          };

          "power-profiles-daemon" = {
            "format" = "{icon}";

            "format-icons" = {
              "balanced" = "󰗑";
              "default" = "󱐌";
              "performance" = "󱐌";
              "power-saver" = "󰌪";
            };

            "tooltip-format" = ''
              Profile: {profile}
              Driver: {driver}'';

            "tooltip" = true;
          };

          "group/hardware" = {
            "orientation" = "horizontal";
            modules = ["pulseaudio" "bluetooth" "network" "power-profiles-daemon" "battery"];
          };

          "group/session" = {
            "orientation" = "horizontal";
            modules = ["custom/dnd" "idle_inhibitor" "custom/logout"];
          };
        };
      };

      systemd.enable = true;
    };

    systemd.user.services.waybar = {
      Install.WantedBy = lib.mkForce ["hyprland-session.target" "sway-session.target"];
      Service = {
        Restart = lib.mkForce "on-failure";
        RestartSec = 5;
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

      #clock,
      #battery,
      #bluetooth,
      #network,
      #power-profiles-daemon,
      #pulseaudio,
      #wireplumber,
      #idle_inhibitor,
      #custom-dnd,
      #custom-logout,
      #custom-menu,
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

      #battery.critical:not(.charging),
      #custom-dnd.on {
          color: #e78284;
      }

      #clock,
      #custom-hyprland-close,
      #custom-menu,
      #hardware,
      #mode,
      #scratchpad,
      #session,
      #submap,
      #tray,
      #workspaces {
          border-radius: 10;
          background: rgba (36, 36, 36, 0.8);
          margin: 5px 10px 0px 10px;
          padding: 0px 10px 0px 10px;
      }

      #clock, #custom-menu, #custom-hyprland-close {
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
