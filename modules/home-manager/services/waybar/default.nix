{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  config = lib.mkIf cfg.services.waybar.enable {
    home.packages =
      (with pkgs; [
        blueberry
        bluez
        coreutils
        getopt
        gnugrep
        libnotify
        mako
        networkmanager
        networkmanager_dmenu
        nwg-drawer
        pavucontrol
        procps
        rofi-power-menu
        systemd
      ])
      ++ lib.optional (cfg.desktop.hyprland.enable) config.wayland.windowManager.hyprland.package;

    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          height = 36;
          layer = "top";
          output = ["*"];
          position = "bottom";
          modules-left =
            ["group/tablet"]
            ++ lib.optionals (cfg.desktop.hyprland.enable)
            ["hyprland/submap"];

          modules-center =
            lib.optionals (cfg.desktop.hyprland.enable)
            ["hyprland/workspaces"];

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
            on-click = ''hyprctl dispatch submap reset'';
          };

          "custom/app-close" = {
            on-click = ''hyprctl dispatch killactive'';
            format = "󰅗";
            tooltip-format = "Close the focused window.";
          };

          "custom/virtual-keyboard" = let
            toggle-virtual-keyboard = pkgs.writeShellScript "toggle-virtual-keyboard" ''
              STATE=`${lib.getExe pkgs.dconf} read /org/gnome/desktop/a11y/applications/screen-keyboard-enabled`

              if [ $STATE -z ] || [ $STATE == "false" ]; then
                if ! [ `pgrep -f ${lib.getExe' pkgs.squeekboard "squeekboard"}` ]; then
                  ${lib.getExe' pkgs.squeekboard "squeekboard"} &
                fi
                ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled true
              elif [ $STATE == "true" ]; then
                ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled false
              fi
            '';
          in {
            on-click = ''${toggle-virtual-keyboard}'';
            format = "󰌌";
            tooltip-format = "Toggle the virtual keyboard.";
          };

          clock = {
            format = "{:%I:%M%p}";
            interval = 60;
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };

          battery = let
            checkBattery = pkgs.writeShellScript "check-battery" (builtins.readFile ./scripts/check-battery.sh);
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
            on-click = "blueberry";
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
            on-click = "pavucontrol -t 3";
            scroll-step = 5;
          };

          network = {
            format-disabled = "󰀝";
            format-disconnected = "󰀦";
            format-ethernet = "󰈀";
            format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
            format-wifi = "{icon}";
            on-click = "networkmanager_dmenu -i";
            tooltip-format = "{ifname} via {gwaddr} 󰊗";
            tooltip-format-disconnected = "Disconnected";
            tooltip-format-ethernet = "{ifname} ";
            tooltip-format-wifi = "{essid} ({signalStrength}%) {icon}";
          };

          tray = {spacing = 15;};

          "custom/dnd" = let
            mako-dnd =
              pkgs.writeShellScript "mako-dnd" (builtins.readFile ./scripts/mako-dnd.sh);
          in {
            exec = "${mako-dnd}";
            interval = "once";
            on-click = "${mako-dnd} toggle";
            return-type = "json";
            signal = 2;
          };

          "custom/logout" = {
            format = "󰤆";
            on-click = ''rofi -i -show power-menu -modi "power-menu:rofi-power-menu --choices=logout/lockscreen/suspend/shutdown/reboot"'';
            tooltip-format = "Manage your session.";
          };

          "custom/menu" = {
            format = "󰀻";
            on-click = "nwg-drawer";
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
              ++ lib.optionals (cfg.desktop.hyprland.tabletMode.enable) ["custom/app-close" "custom/virtual-keyboard"];

            orientation = "horizontal";
          };

          "group/hardware" = {
            modules =
              ["pulseaudio" "bluetooth" "network"] ++ lib.lists.optionals (cfg.desktop.hyprland.laptopMonitor != null) ["power-profiles-daemon" "battery"];

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
          #custom-virtual-keyboard,
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

          #waybar {
            border-radius: 0;
          }
      '';

      systemd.enable = true;
    };

    systemd.user.services.waybar = {
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target");

      Service.Restart = lib.mkForce "no";

      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target";
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
