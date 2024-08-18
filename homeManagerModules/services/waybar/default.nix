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
            on-click = "${lib.getExe' config.wayland.windowManager.sway.package "swaymsg"} scratchpad show";
            show-empty = false;
            tooltip = true;
            tooltip-format = "{app}: {title}";
          };

          "custom/app-close" = {
            on-click = ''${lib.getExe'
                config.wayland.windowManager.hyprland.package "hyprctl"} dispatch killactive || ${lib.getExe' config.wayland.windowManager.sway.package "swaymsg"} kill'';
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
              "custom/app-close";

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

      style = lib.mkAfter ''
        ${
          lib.optionalString (config.stylix.polarity == "light") "
          tooltip {
            background: alpha(@base05, ${builtins.toString config.stylix.opacity.desktop});
            color: ${config.lib.stylix.colors.withHashtag.base00};
          }"
        }

          tooltip {
            border-radius: ${toString cfg.theme.borders.radius}px;
          }

          #battery,
          #bluetooth,
          #clock,
          #custom-dnd,
          #custom-app-close,
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

          #clock,
          #tablet,
          #hardware,
          #mode,
          #scratchpad,
          #session,
          #submap,
          #tray,
          #workspaces {
            margin: 0px 5px;
            padding: 0px 2.5px;
          }

          #workspaces button {
            border-radius: 0px;
          }

          #workspaces button.active,
          #workspaces button.focused {
            color: ${config.lib.stylix.colors.withHashtag.base0D};
          }

          #battery.charging,
          #power-profiles-daemon.power-saver {
            color: ${config.lib.stylix.colors.withHashtag.base0B};
          }

          #battery.critical:not(.charging),
          #custom-dnd.on,
          #idle_inhibitor.activated,
          #network.disabled,
          #network.disconnected,
          #power-profiles-daemon.performance,
          #pulseaudio.muted {
            color: ${config.lib.stylix.colors.withHashtag.base08};
          }

          #submap,
          #mode {
            background-color: ${config.lib.stylix.colors.withHashtag.base08};
            border-radius: ${toString cfg.theme.borders.radius}px;
            color: ${config.lib.stylix.colors.withHashtag.base00};
            font-weight: bold;
          }
      '';

      systemd.enable = true;
    };

    systemd.user.services.waybar = {
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target");
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target";
    };

    xdg.configFile."nwg-drawer/drawer.css".text = ''
      window {
        background-color: alpha (${config.lib.stylix.colors.withHashtag.base00}, ${toString config.stylix.opacity.popups});
        color: ${config.lib.stylix.colors.withHashtag.base05}
      }

      /* search entry */
      entry {
        background-color: rgba (0, 0, 0, 0.2);
        border: alpha(${config.lib.stylix.colors.withHashtag.base07}, ${toString config.stylix.opacity.popups});
        border-radius: ${toString cfg.theme.borders.radius}px
      }

      button, image {
        background: none;
        border: none;
        border-radius: ${toString cfg.theme.borders.radius}px
      }

      button:active, button:hover, button:focused {
        background-color: alpha (${config.lib.stylix.colors.withHashtag.base05}, 0.2);
        border: none;
        border-radius: ${toString cfg.theme.borders.radius}px;
        color: ${config.lib.stylix.colors.withHashtag.base0D}
      }

      #category-button {
        margin: 0 10px 0 10px;
        border-radius: ${toString cfg.theme.borders.radius}px
      }

      #pinned-box {
        padding-bottom: 5px;
        border-bottom: 1px dotted gray
      }

      #files-box {
        padding: 5px;
        border: 1px dotted gray;
        border-radius: ${toString cfg.theme.borders.radius}px
      }
    '';
  };
}
