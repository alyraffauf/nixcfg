{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.desktop.hyprland.enable {
    wayland.windowManager = {
      hyprland.enable = true;

      hyprland.settings = let
        inherit
          (import ./vars.nix {inherit config lib pkgs;})
          brightness
          defaultApps
          defaultWorkspaces
          layerRules
          media
          modifier
          screenshot
          volume
          windowManagerBinds
          windowRules
          ;

        inherit (import ./scripts.nix {inherit config lib pkgs;}) clamshell idleD wallpaperD;

        # Hyprland desktop utilities
        hyprnome = lib.getExe pkgs.hyprnome;
      in {
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "specialWorkspace, 1, 6, default, slidevert"
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "workspaces, 1, 6, default"
          ];
        };

        bind = [
          "${modifier}, B, exec, ${defaultApps.browser}"
          "${modifier}, E, exec, ${defaultApps.editor}"
          "${modifier}, F, exec, ${defaultApps.fileManager}"
          "${modifier}, R, exec, ${defaultApps.launcher}"
          "${modifier}, T, exec, ${defaultApps.terminal}"
          # Manage session.
          "${modifier}, C, killactive"
          "${modifier} CONTROL, L, exec, ${defaultApps.lock}"
          "${modifier}, M, exec, ${defaultApps.logout}"
          # Basic window management.
          "${modifier} SHIFT, W, fullscreen"
          "${modifier} SHIFT, V, togglefloating"
          "${modifier} SHIFT, backslash, togglesplit"
          # Gnome-like workspaces.
          "${modifier}, comma, exec, ${hyprnome} --previous"
          "${modifier}, period, exec, ${hyprnome}"
          "${modifier} SHIFT, comma, exec, ${hyprnome} --previous --move"
          "${modifier} SHIFT, period, exec, ${hyprnome} --move"
          # Scratchpad show and move
          "${modifier}, S, togglespecialworkspace, magic"
          "${modifier} SHIFT, S, movetoworkspace, special:magic"
          # Scroll through existing workspaces with mainMod + scroll
          "${modifier}, mouse_down, workspace, +1"
          "${modifier}, mouse_up, workspace, -1"
          # Screenshot with hyprshot.
          ", PRINT, exec, ${screenshot.screen}"
          "${modifier}, PRINT, exec, ${screenshot.region}"
          "CONTROL, F12, exec, ${screenshot.screen}"
          "${modifier} CONTROL, F12, exec, ${screenshot.region}"
          # Show/hide waybar.
          "${modifier}, F11, exec, pkill -SIGUSR1 waybar"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "${modifier}, mouse:272, movewindow"
          "${modifier}, mouse:273, resizewindow"
        ];

        bindl =
          [
            # Volume, microphone, and media keys.
            ", xf86audiomute, exec, ${volume.mute}"
            ", xf86audiomicmute, exec, ${volume.micMute}"
            ", xf86audioplay, exec, ${media.play}"
            ", xf86audioprev, exec, ${media.prev}"
            ", xf86audionext, exec, ${media.next}"
          ]
          ++ lib.lists.optional (cfg.desktop.hyprland.laptopMonitors != [])
          ''
            # Turn off the internal display when lid is closed.
            bindl = ,switch:on:Lid Switch,exec,${clamshell} on
            bindl = ,switch:off:Lid Switch,exec,${clamshell} off
          '';

        bindle = [
          # Display, volume, microphone, and media keys.
          ", xf86monbrightnessup, exec, ${brightness.up}"
          ", xf86monbrightnessdown, exec, ${brightness.down}"
          ", xf86audioraisevolume, exec, ${volume.up}"
          ", xf86audiolowervolume, exec, ${volume.down}"
        ];

        dwindle = {
          preserve_split = true;
        };

        exec-once =
          [
            wallpaperD
            (lib.getExe pkgs.waybar)
            idleD
            (lib.getExe pkgs.wayland-pipewire-idle-inhibit)
            (lib.getExe' pkgs.blueman "blueman-applet")
            (lib.getExe' pkgs.networkmanagerapplet "nm-applet")
            (lib.getExe' pkgs.playerctl "playerctld")
            (lib.getExe' pkgs.swayosd "swayosd-server")
            (lib.getExe pkgs.mako)
            "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1"
          ]
          ++ lib.lists.optional (cfg.desktop.hyprland.redShift)
          "${lib.getExe pkgs.gammastep} -l 33.74:-84.38";

        input = {
          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          kb_layout = "us";
          kb_variant = "altgr-intl";
          follow_mouse = 1;
          sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
          touchpad = {
            clickfinger_behavior = true;
            drag_lock = true;
            middle_button_emulation = true;
            natural_scroll = true;
            tap-to-click = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 6;
          border_size = 2;
          "col.active_border" = "rgba(${lib.strings.removePrefix "#" cfg.theme.colors.secondary}EE) rgba(${lib.strings.removePrefix "#" cfg.theme.colors.primary}EE) 45deg";
          "col.inactive_border" = "rgba(${lib.strings.removePrefix "#" cfg.theme.colors.inactive}AA)";
          layout = "dwindle";
          allow_tearing = false;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_touch = true;
        };

        master = {
          always_center_master = true;
          new_status = false;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
          vfr = true;
        };

        monitor = ",preferred,auto,auto";

        # unscale XWayland apps
        xwayland.force_zero_scaling = true;
      };

      hyprland.extraConfig = let
        inherit
          (import ./vars.nix {inherit config lib pkgs;})
          defaultWorkspaces
          layerRules
          modifier
          windowManagerBinds
          windowRules
          ;

        inherit (import ./scripts.nix {inherit config lib pkgs;}) tablet;

        # Hyprland desktop utilities
        hyprnome = lib.getExe pkgs.hyprnome;
      in ''
        ${
          lib.strings.concatMapStringsSep "\n"
          (monitor: ''monitor = ${monitor}'')
          (cfg.desktop.hyprland.laptopMonitors
            ++ cfg.desktop.hyprland.monitors)
        }

        # Enable virtual keyboard in tablet mode
        ${
          lib.strings.concatMapStringsSep "\n"
          (switch: ''bindl = ,switch:${switch},exec,${tablet}'')
          cfg.desktop.hyprland.tabletMode.tabletSwitches
        }

        # Some default env vars.
        env = XCURSOR_SIZE,${toString config.home.pointerCursor.size}
        env = QT_QPA_PLATFORMTHEME,qt6ct

        decoration {
          rounding = 10
          blur {
            enabled = true
            size = 8
            passes = 1
          }
          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(${lib.strings.removePrefix "#" cfg.theme.colors.shadow}EE)
          dim_special = 0.5
          ${layerRules}
        }

        # Window Rules
        ${windowRules}

        # Move focus with mainMod + keys ++
        # Move window with mainMod SHIFT + keys ++
        # Move workspace to another output with mainMod CONTROL SHIFT + keys.
        ${
          lib.strings.concatLines
          (
            lib.attrsets.mapAttrsToList (key: direction: ''
              bind = ${modifier}, ${key}, movefocus, ${direction}
              bind = ${modifier} SHIFT, ${key}, movewindow, ${direction}
              bind = ${modifier} CONTROL SHIFT, ${key}, movecurrentworkspacetomonitor, ${direction}
            '')
            windowManagerBinds
          )
        }

        # Switch workspaces with mainMod + [1-9] ++
        # Move active window to a workspace with mainMod + SHIFT + [1-9].
        ${
          lib.strings.concatMapStringsSep "\n"
          (x: ''
            bind = ${modifier}, ${toString x}, workspace, ${toString x}
            bind = ${modifier} SHIFT, ${toString x}, movetoworkspace, ${toString x}
          '')
          defaultWorkspaces
        }

        bind=CTRL ALT,R,submap,resize
        submap=resize
        binde=,down,resizeactive,0 10
        binde=,left,resizeactive,-10 0
        binde=,right,resizeactive,10 0
        binde=,up,resizeactive,0 -10
        binde=,j,resizeactive,0 10
        binde=,h,resizeactive,-10 0
        binde=,l,resizeactive,10 0
        binde=,k,resizeactive,0 -10
        bind=,escape,submap,reset
        submap=reset

        bind=CTRL ALT,M,submap,move
        submap=move
        # Move window with keys ++
        # Move workspaces across monitors with CONTROL + keys.
        ${
          lib.strings.concatLines
          (
            lib.attrsets.mapAttrsToList (key: direction: ''
              bind = , ${key}, movewindow, ${direction}
              bind = CONTROL, ${key}, movecurrentworkspacetomonitor, ${direction}
            '')
            windowManagerBinds
          )
        }

        # Move active window to a workspace with [1-9]
        ${
          lib.strings.concatMapStringsSep "\n"
          (x: "bind = , ${toString x}, movetoworkspace, ${toString x}")
          defaultWorkspaces
        }

        # hyprnome
        bind = , comma, exec, ${hyprnome} --previous --move
        bind = , period, exec, ${hyprnome} --move
        bind=,escape,submap,reset
        submap=reset
      '';
    };
  };
}
