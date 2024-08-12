{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.waybar.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          height = 34;
          layer = "top";
          output = ["*"];
          position = "bottom";
          modules-left =
            ["group/tablet"]
            ++ lib.optionals (cfg.desktop.hyprland.enable)
            ["hyprland/submap"]
            ++ lib.optionals (cfg.desktop.sway.enable)
            ["sway/scratchpad" "sway/mode"];

          modules-center =
            lib.optionals (cfg.desktop.hyprland.enable)
            ["hyprland/workspaces"]
            ++ lib.optionals (cfg.desktop.sway.enable)
            ["sway/workspaces"];

          modules-right = [
            "tray"
            "group/hardware"
            "clock"
            "group/session"
          ];

          "hyprland/workspaces" = {
            all-outputs = true;
            format = "{icon} {name}";

            format-icons = {
              active = "󰪥";
              default = "󰝥";
              urgent = "";
            };

            sort-by = "id";
          };

          "hyprland/submap" = {
            on-click = ''${lib.getExe'
                config.wayland.windowManager.hyprland.package "hyprctl"} dispatch submap reset'';
          };

          "sway/workspaces" = {
            all-outputs = true;
            format = "{icon} {name}";

            format-icons = {
              default = "󰝥";
              focused = "󰪥";
              urgent = "";
            };

            sort-by = "id";
          };

          "sway/mode" = {
            on-click = ''${lib.getExe' config.wayland.windowManager.sway.package "swaymsg"} mode default'';
          };

          "sway/scratchpad" = {
            format = "{icon}　{count}";
            format-icons = ["" ""];
            show-empty = false;
            tooltip = true;
            tooltip-format = "{app}: {title}";
          };

          "custom/hyprland-close" = {
            on-click = ''${lib.getExe'
                config.wayland.windowManager.hyprland.package "hyprctl"} dispatch killactive'';
            format = "󰅗";
            tooltip-format = "Close the focused window.";
          };

          clock = {
            format = "{:%I:%M%p}";
            interval = 60;
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };

          battery = let
            checkBattery = pkgs.writeShellScript "check-battery" ''
              if [ -d /sys/class/power_supply/BAT0 ]; then
                BAT=/sys/class/power_supply/BAT0
              elif [ -d /sys/class/power_supply/BAT1 ]; then
                BAT=/sys/class/power_supply/BAT1
              else
                echo "No battery found."
                exit 1
              fi
              CRIT=''${1:-10}
              NOTIFY=${lib.getExe' pkgs.libnotify "notify-send"}

              stat=$(${lib.getExe' pkgs.coreutils "cat"} $BAT/status)
              perc=$(${lib.getExe' pkgs.coreutils "cat"} $BAT/capacity)

              if [[ $perc -le $CRIT ]] && [[ $stat == "Discharging" ]]; then
                $NOTIFY --urgency=critical --icon=dialog-error "Battery Critical" "Current charge: $perc%".
              fi
            '';
          in {
            format = "{icon}";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];

            on-update = "${checkBattery}";
            tooltip-format = ''
              {capacity}%: {timeTo}.
              Draw: {power} watts.'';

            states = {critical = 20;};
          };

          idle_inhibitor = {
            format = "{icon}";

            format-icons = {
              activated = "󰅶";
              deactivated = "󰾪";
            };

            timeout = 45;

            tooltip-format-activated = ''
              Presentation mode enabled.
              System will not sleep.'';

            tooltip-format-deactivated = ''
              Presentation mode disabled.
              System will sleep normally.'';
          };

          bluetooth = {
            format = "";
            format-connected = "　{num_connections}";
            format-disabled = ""; # an empty format will hide the module
            on-clic = lib.getExe' pkgs.blueberry "blueberry";
            tooltip-format = "{controller_alias}	{controller_address}";

            tooltip-format-connected = ''
              {controller_alias}	{controller_address}

              {device_enumerate}'';

            tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
          };

          pulseaudio = {
            format = "{icon}";
            format-bluetooth = "{volume}% {icon}󰂯";
            format-muted = "";

            format-icons = {
              headphones = "󰋋";
              handsfree = "󰋎";
              headset = "󰋎";
              default = ["" "" ""];
            };

            ignored-sinks = ["Easy Effects Sink"];
            on-click = "${lib.getExe pkgs.pavucontrol} -t 3";
            scroll-step = 5;
          };

          network = {
            format-disabled = "󰀝";
            format-disconnected = "󰀦";
            format-ethernet = "󰈀";
            format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
            format-wifi = "{icon}";
            on-click = "${lib.getExe pkgs.networkmanager_dmenu} -i";
            tooltip-format = "{ifname} via {gwaddr} 󰊗";
            tooltip-format-disconnected = "Disconnected";
            tooltip-format-ethernet = "{ifname} ";
            tooltip-format-wifi = "{essid} ({signalStrength}%) {icon}";
          };

          tray = {spacing = 15;};

          "custom/dnd" = let
            mako-dnd = pkgs.writeShellScript "mako-dnd" ''
              show() {
                  MAKO_MODE=$(${lib.getExe' pkgs.mako "makoctl"} mode)
                  if ${lib.getExe' pkgs.coreutils "echo"} "$MAKO_MODE" | ${lib.getExe' pkgs.gnugrep "grep"} -q "do-not-disturb"; then
                      ${lib.getExe' pkgs.coreutils "printf"} '{"text": "󰂛", "class": "on", "tooltip": "Notifications snoozed."}\n'
                  else
                      ${lib.getExe' pkgs.coreutils "printf"} '{"text": "󰂚", "class": "off","tooltip": "Notifications enabled."}\n'
                  fi
              }

              toggle() {
                  ${lib.getExe' pkgs.mako "makoctl"} mode -t do-not-disturb
                  ${lib.getExe' pkgs.procps "pkill"} -SIGRTMIN+2 .waybar-wrapped
              }

              [ $# -gt 0 ] && toggle || show
            '';
          in {
            exec = "${mako-dnd}";
            interval = "once";
            on-click = "${mako-dnd} toggle";
            return-type = "json";
            signal = 2;
          };

          "custom/logout" = {
            format = "󰤆";
            on-click = ''${lib.getExe config.programs.rofi.package} -i -show power-menu -modi "power-menu:${lib.getExe pkgs.rofi-power-menu} --choices=logout/lockscreen/suspend/shutdown/reboot"'';
            tooltip-format = "Manage your session.";
          };

          "custom/menu" = {
            format = "󰀻";
            on-click = "${lib.getExe pkgs.nwg-drawer}";
            tooltip-format = "Touch-friendly application menu.";
          };

          power-profiles-daemon = {
            format = "{icon}";

            format-icons = {
              balanced = "󰗑";
              default = "󰗑";
              performance = "󱐌";
              power-saver = "󰌪";
            };

            tooltip-format = ''
              Profile: {profile}
              Driver: {driver}'';

            tooltip = true;
          };

          "group/tablet" = {
            modules =
              ["custom/menu"]
              ++ lib.optional (cfg.desktop.hyprland.tabletMode.enable)
              "custom/hyprland-close";

            orientation = "horizontal";
          };

          "group/hardware" = {
            modules = ["pulseaudio" "bluetooth" "network" "power-profiles-daemon" "battery"];
            orientation = "horizontal";
          };

          "group/session" = {
            modules = ["custom/dnd" "idle_inhibitor" "custom/logout"];
            orientation = "horizontal";
          };
        };
      };

      style = ''
        * {
          border-radius: 0px;
          border: none;
          font-family: "${cfg.theme.sansFont.name}", FontAwesome, sans-serif;
          font-size: ${toString (cfg.theme.sansFont.size + 3)}px;
          font-weight: bold;
        }

        window#waybar {
          background-color: alpha(${cfg.theme.colors.background}, 0.8);
          color: ${cfg.theme.colors.text};
        }

        tooltip {
          background-color: ${cfg.theme.colors.background};
          color: ${cfg.theme.colors.text};
        }

        #workspaces button {
          border-radius: ${toString cfg.theme.borderRadius};
          color: ${cfg.theme.colors.text};
          margin: 0px 0px;
          padding: 0px 5px;
        }

        #workspaces button.active,
        #workspaces button.focused {
          color: ${cfg.theme.colors.secondary};
        }

        #battery,
        #bluetooth,
        #clock,
        #custom-dnd,
        #custom-hyprland-close,
        #custom-logout,
        #custom-menu,
        #idle_inhibitor,
        #mode,
        #network,
        #power-profiles-daemon,
        #pulseaudio,
        #submap,
        #tray,
        #wireplumber {
          margin: 0px 5px;
          padding: 0px 5px;
        }

        #battery.charging,
        #power-profiles-daemon.power-saver {
          color: ${cfg.theme.colors.primary};
        }

        #battery.critical:not(.charging),
        #custom-dnd.on,
        #idle_inhibitor.activated,
        #network.disabled,
        #network.disconnected,
        #power-profiles-daemon.performance,
        #pulseaudio.muted {
          color: ${cfg.theme.colors.secondary};
        }

        #clock,
        #tablet,
        #hardware,
        #mode,
        #scratchpad,
        #session,
        #submap,
        #tray,
        #workspaces {
          margin: 5px 5px;
          padding: 0px 2.5px;
        }

        #submap,
        #mode {
          background-color: ${cfg.theme.colors.secondary};
          border-radius: ${toString cfg.theme.borderRadius};
          color: ${cfg.theme.colors.background};
        }
      '';

      systemd.enable = true;
    };

    systemd.user.services.waybar = {
      Install.WantedBy = lib.mkForce ["hyprland-session.target" "sway-session.target"];
      Service = {
        Restart = lib.mkForce "on-failure";
        RestartSec = 5;
      };
    };

    xdg.configFile."nwg-drawer/drawer.css".text = ''
      window {
        background-color: alpha (${cfg.theme.colors.background}, 0.8);
        color: ${cfg.theme.colors.text}
      }

      /* search entry */
      entry {
        background-color: rgba (0, 0, 0, 0.2);
        border: 4px solid ${cfg.theme.colors.primary};
        border-radius: ${toString cfg.theme.borderRadius}px
      }

      button, image {
        background: none;
        border: none;
        border-radius: ${toString cfg.theme.borderRadius}px
      }

      button:active, button:hover, button:focused {
        background-color: alpha (${cfg.theme.colors.text}, 0.2);
        border: none;
        border-radius: ${toString cfg.theme.borderRadius}px;
        color: ${cfg.theme.colors.secondary}
      }

      #category-button {
        margin: 0 10px 0 10px;
        border-radius: ${toString cfg.theme.borderRadius}px
      }

      #pinned-box {
        padding-bottom: 5px;
        border-bottom: 1px dotted gray
      }

      #files-box {
        padding: 5px;
        border: 1px dotted gray;
        border-radius: ${toString cfg.theme.borderRadius}px
      }
    '';
  };
}
