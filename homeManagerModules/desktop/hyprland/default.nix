{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  config = let
    cfg = config.ar.home;
  in
    lib.mkIf cfg.desktop.hyprland.enable {
      wayland.windowManager.hyprland.enable = true;

      wayland.windowManager.hyprland.extraConfig = let
        inherit
          (import ./vars.nix)
          defaultWorkspaces
          externalMonitors
          laptopMonitors
          layerRules
          modifier
          windowManagerBinds
          windowRules
          ;

        # Hyprland desktop utilities
        hyprnome = lib.getExe pkgs.hyprnome;
        hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";

        # Default apps
        defaultApps = {
          browser = lib.getExe cfg.defaultApps.webBrowser;
          editor = lib.getExe cfg.defaultApps.editor;
          fileManager = lib.getExe cfg.defaultApps.fileManager;
          launcher = lib.getExe pkgs.fuzzel;
          lock = lib.getExe pkgs.swaylock;
          logout = lib.getExe pkgs.wlogout;
          terminal = lib.getExe cfg.defaultApps.terminal;
          virtKeyboard = lib.getExe' pkgs.squeekboard "squeekboard";
        };

        wallpaperd =
          if cfg.desktop.hyprland.randomWallpaper
          then
            pkgs.writers.writeRuby "hyprland-randomWallpaper" {} ''
              require 'fileutils'

              directory = "${self.inputs.wallpapers.packages.${pkgs.system}.default}/share/backgrounds"
              hyprctl = "${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"}"
              old_pids = []

              sleep 1

              if Dir.exist?(directory)
                loop do
                  new_pids = []

                  outputs = IO.popen([hyprctl, 'monitors']).read
                  monitors = outputs.each_line.map { |line| line.split[1] if line.include?('Monitor') }.compact

                  monitors.each do |monitor|
                    random_background = Dir.glob(File.join(directory, '*.{png,jpg}')).sample
                    pid = spawn("${lib.getExe pkgs.swaybg}", '-o', monitor, '-i', random_background, '-m', 'fill')
                    new_pids << pid
                  end

                  if old_pids.empty?
                    sleep 900
                  else
                    sleep 5
                    old_pids.each do |pid|
                      Process.kill('TERM', pid)
                    end
                    sleep 895
                  end

                  old_pids = new_pids
                end
              end
            ''
          else "${lib.getExe pkgs.swaybg} -i ${cfg.theme.wallpaper}";

        startupApps =
          [
            wallpaperd
            (lib.getExe pkgs.waybar)
            idled
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

        screenshot = rec {
          bin = lib.getExe pkgs.hyprshot;
          folder = "${config.xdg.userDirs.pictures}/screenshots";
          screen = "${bin} -m output -o ${folder}";
          region = "${bin} -m region -o ${folder}";
        };

        clamshell = pkgs.writeShellScript "hyprland-clamshell" ''
          NUM_MONITORS=$(${hyprctl} monitors all | grep Monitor | wc --lines)
          if [ "$1" == "on" ]; then
            if [ $NUM_MONITORS -gt 1 ]; then
              ${hyprctl} keyword monitor "eDP-1, disable"
            fi
          elif [ "$1" == "off" ]; then
            ${
            lib.strings.concatLines
            (
              lib.attrsets.mapAttrsToList (name: monitor: ''${hyprctl} keyword monitor "${monitor}"'')
              laptopMonitors
            )
          }
          fi
        '';

        tablet = pkgs.writeShellScript "hyprland-tablet" ''
          STATE=`${lib.getExe pkgs.dconf} read /org/gnome/desktop/a11y/applications/screen-keyboard-enabled`

          if [ $STATE -z ] || [ $STATE == "false" ]; then
            if ! [ `pgrep -f ${defaultApps.virtKeyboard}` ]; then
              ${defaultApps.virtKeyboard} &
            fi
            ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled true
          elif [ $STATE == "true" ]; then
            ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled false
          fi
        '';

        # Media/hardware commands
        brightness = rec {
          bin = lib.getExe' pkgs.swayosd "swayosd-client";
          up = "${bin} --brightness=raise";
          down = "${bin} --brightness=lower";
        };

        volume = rec {
          bin = lib.getExe' pkgs.swayosd "swayosd-client";
          up = "${bin} --output-volume=raise";
          down = "${bin} --output-volume=lower";
          mute = "${bin} --output-volume=mute-toggle";
          micMute = "${bin} --input-volume=mute-toggle";
        };

        media = rec {
          bin = lib.getExe pkgs.playerctl;
          play = "${bin} play-pause";
          paus = "${bin} pause";
          next = "${bin} next";
          prev = "${bin} previous";
        };

        idled = pkgs.writeShellScript "hyprland-idled" ''
          ${lib.getExe pkgs.swayidle} -w \
            before-sleep '${media.paus}' \
            before-sleep '${defaultApps.lock}' \
            timeout 240 '${lib.getExe pkgs.brightnessctl} -s set 10' \
              resume '${lib.getExe pkgs.brightnessctl} -r' \
            timeout 300 '${defaultApps.lock}' \
            timeout 330 '${hyprctl} dispatch dpms off' \
              resume '${hyprctl} dispatch dpms on' \
            ${
            if cfg.desktop.hyprland.autoSuspend
            then ''timeout 900 'sleep 2 && ${lib.getExe' pkgs.systemd "systemctl"} suspend' \''
            else ''\''
          }
        '';
      in ''
          ${
          lib.strings.concatLines
          (
            lib.attrsets.mapAttrsToList (name: value: "monitor = ${value}")
            (laptopMonitors // externalMonitors)
          )
        }
          monitor = ,preferred,auto,auto

          # Turn off the internal display when lid is closed.
          bindl=,switch:on:Lid Switch,exec,${clamshell} on
          bindl=,switch:off:Lid Switch,exec,${clamshell} off

          # Enable virtual keyboard in tablet mode
          bindl=,switch:Lenovo Yoga Tablet Mode Control switch,exec,${tablet}

          # unscale XWayland apps
          xwayland {
            force_zero_scaling = true
          }

          # Some default env vars.
          env = XCURSOR_SIZE,${toString config.home.pointerCursor.size}
          env = QT_QPA_PLATFORMTHEME,qt6ct

          # Execute necessary apps
          ${
          lib.strings.concatMapStringsSep
          "\n"
          (x: "exec-once = ${x}")
          startupApps
        }

          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input {
            kb_layout = us
            kb_variant = altgr-intl
            follow_mouse = 1
            sensitivity = 0 # -1.0 to 1.0, 0 means no modification.
            tablet {
              output = eDP-1
            }
            touchdevice {
              output = eDP-1
            }
            touchpad {
              clickfinger_behavior = true
              drag_lock = true
              middle_button_emulation = true
              natural_scroll = true
              tap-to-click = true
            }
          }

          gestures {
            workspace_swipe = true
            workspace_swipe_touch = true
          }

          general {
            gaps_in = 5
            gaps_out = 6
            border_size = 2
            col.active_border = rgba(${lib.strings.removePrefix "#" cfg.theme.colors.secondary}EE) rgba(${lib.strings.removePrefix "#" cfg.theme.colors.primary}EE) 45deg
            col.inactive_border = rgba(${lib.strings.removePrefix "#" cfg.theme.colors.inactive}AA)

            layout = dwindle

            allow_tearing = false
          }

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

            # Window-specific rules
            ${layerRules}
          }

          animations {
            enabled = yes
            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = border, 1, 10, default
            animation = borderangle, 1, 8, default
            animation = fade, 1, 7, default
            animation = specialWorkspace, 1, 6, default, slidevert
            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = workspaces, 1, 6, default
          }

          dwindle {
            preserve_split = yes
          }

          master {
            always_center_master = true
            new_status = false
          }

          misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
            focus_on_activate = true
            vfr = true
          }

          # Window Rules
          ${windowRules}

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          bind = ${modifier}, B, exec, ${defaultApps.browser}
          bind = ${modifier}, E, exec, ${defaultApps.editor}
          bind = ${modifier}, F, exec, ${defaultApps.fileManager}
          bind = ${modifier}, R, exec, ${defaultApps.launcher}
          bind = ${modifier}, T, exec, ${defaultApps.terminal}

          # Manage session.
          bind = ${modifier}, C, killactive,
          bind = ${modifier} CONTROL, L, exec, ${defaultApps.lock}
          bind = ${modifier}, M, exec, ${defaultApps.logout}

          # Basic window management.
          bind = ${modifier} SHIFT, W, fullscreen
          bind = ${modifier} SHIFT, V, togglefloating,
          # bind = ${modifier} SHIFT, P, pseudo, # dwindle
          bind = ${modifier} SHIFT, backslash, togglesplit, # dwindle

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

          # Gnome-like workspaces.
          bind = ${modifier}, comma, exec, ${hyprnome} --previous
          bind = ${modifier}, period, exec, ${hyprnome}
          bind = ${modifier} SHIFT, comma, exec, ${hyprnome} --previous --move
          bind = ${modifier} SHIFT, period, exec, ${hyprnome} --move

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

          # Scratchpad show and move
          bind = ${modifier}, S, togglespecialworkspace, magic
          bind = ${modifier} SHIFT, S, movetoworkspace, special:magic

          # Scroll through existing workspaces with mainMod + scroll
          bind = ${modifier}, mouse_down, workspace, +1
          bind = ${modifier}, mouse_up, workspace, -1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = ${modifier}, mouse:272, movewindow
          bindm = ${modifier}, mouse:273, resizewindow

          # Display, volume, microphone, and media keys.
          bindle = , xf86monbrightnessup, exec, ${brightness.up}
          bindle = , xf86monbrightnessdown, exec, ${brightness.down}
          bindle = , xf86audioraisevolume, exec, ${volume.up};
          bindle = , xf86audiolowervolume, exec, ${volume.down};
          bindl = , xf86audiomute, exec, ${volume.mute}
          bindl = , xf86audiomicmute, exec, ${volume.micMute}
          bindl = , xf86audioplay, exec, ${media.play}
          bindl = , xf86audioprev, exec, ${media.prev}
          bindl = , xf86audionext, exec, ${media.next}

          # Screenshot with hyprshot.
          bind = , PRINT, exec, ${screenshot.screen}
          bind = ${modifier}, PRINT, exec, ${screenshot.region}
          bind = CONTROL, F12, exec, ${screenshot.screen}
          bind = ${modifier} CONTROL, F12, exec, ${screenshot.region}

          # Show/hide waybar.
          bind = ${modifier}, F11, exec, pkill -SIGUSR1 waybar

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
}
