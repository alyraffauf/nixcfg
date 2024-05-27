{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}: {
  imports = [./randomWallpaper.nix ./redShift.nix ./virtKeyboard.nix];

  options = {
    alyraffauf.desktop.hyprland = {
      enable =
        lib.mkEnableOption "Enables hyprland with extra apps.";
      autoSuspend = lib.mkOption {
        description = "Whether to autosuspend on idle.";
        default = config.alyraffauf.desktop.hyprland.enable;
        type = lib.types.bool;
      };
      randomWallpaper = lib.mkOption {
        description = "Whether to enable random wallpaper script.";
        default = config.alyraffauf.desktop.hyprland.enable;
        type = lib.types.bool;
      };
      redShift = lib.mkOption {
        description = "Whether to redshift display colors at night.";
        default = config.alyraffauf.desktop.hyprland.enable;
        type = lib.types.bool;
      };
      tabletMode = {
        enable = lib.mkEnableOption "Tablet mode for hyprland.";
        autoRotate = lib.mkOption {
          description = "Whether to autorotate screen.";
          default = config.alyraffauf.desktop.hyprland.tabletMode.enable;
          type = lib.types.bool;
        };
        menuButton = lib.mkOption {
          description = "Whether to add menu button for waybar.";
          default = config.alyraffauf.desktop.hyprland.tabletMode.enable;
          type = lib.types.bool;
        };
        virtKeyboard = lib.mkOption {
          description = "Whether to enable dynamic virtual keyboard.";
          default = config.alyraffauf.desktop.hyprland.tabletMode.enable;
          type = lib.types.bool;
        };
      };
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.hyprland.enable {
    alyraffauf = {
      desktop = {
        waylandComp = lib.mkDefault true;
      };
    };

    xdg.portal = {
      enable = true;
      configPackages = [inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".xdg-desktop-portal-hyprland];
      extraPortals = [inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".xdg-desktop-portal-hyprland];
    };

    programs.waybar = {
      settings = {
        mainBar = {
          modules-left =
            if config.alyraffauf.desktop.hyprland.tabletMode.menuButton
            then ["hyprland/workspaces" "custom/menu" "custom/hyprland-close" "hyprland/submap"]
            else ["hyprland/workspaces" "hyprland/submap"];
        };
      };
    };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.package = inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".hyprland;
    wayland.windowManager.hyprland.extraConfig = let
      modifier = "SUPER";

      # Default apps
      browser = config.alyraffauf.desktop.defaultApps.webBrowser.exe;
      fileManager = lib.getExe pkgs.xfce.thunar;
      editor = config.alyraffauf.desktop.defaultApps.editor.exe;
      terminal = config.alyraffauf.desktop.defaultApps.terminal.exe;

      # Media/hardware commands
      brightness = lib.getExe' pkgs.swayosd "swayosd-client";
      brightness_up = "${brightness} --brightness=raise";
      brightness_down = "${brightness} --brightness=lower";
      volume = brightness;
      volume_up = "${volume} --output-volume=raise";
      volume_down = "${volume} --output-volume=lower";
      volume_mute = "${volume} --output-volume=mute-toggle";
      mic_mute = "${volume} --input-volume=mute-toggle";
      media = lib.getExe pkgs.playerctl;
      media_play = "${media} play-pause";
      media_next = "${media} next";
      media_prev = "${media} previous";

      # Hyprland desktop utilities
      bar = lib.getExe pkgs.waybar;
      launcher = lib.getExe pkgs.fuzzel;
      notifyd = lib.getExe pkgs.mako;
      wallpaperd = "${lib.getExe pkgs.swaybg} -i ${config.alyraffauf.desktop.theme.wallpaper}";
      logout = lib.getExe pkgs.wlogout;
      lock = lib.getExe pkgs.swaylock;

      idled = pkgs.writeShellScript "hyprland-idled" ''
        ${lib.getExe pkgs.swayidle} -w \
          before-sleep '${media} pause' \
          before-sleep '${lock}' \
          timeout 240 '${lib.getExe pkgs.brightnessctl} -s set 10' \
            resume '${lib.getExe pkgs.brightnessctl} -r' \
          timeout 300 '${lock}' \
          timeout 330 '${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms off' \
            resume '${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on' \
          ${
          if config.alyraffauf.desktop.hyprland.autoSuspend
          then ''timeout 900 '${lib.getExe' pkgs.systemd "systemctl"} suspend' \''
          else ''\''
        }
      '';

      hyprnome = lib.getExe inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".hyprnome;

      screenshot = lib.getExe inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".hyprshot;
      screenshot_folder = "~/pics/screenshots";
      screenshot_screen = "${screenshot} -m output -o ${screenshot_folder}";
      screenshot_region = "${screenshot} -m region -o ${screenshot_folder}";

      qt_platform_theme = "gtk2";
      gdk_scale = "1.5";
    in ''
      $framework = desc:BOE 0x095F,preferred,auto,1.6 # lavaridge/fallarbor fw13 glossy display
      $t440p = desc:LG Display 0x0569,preferred,auto,1.2 # rustboro
      $yoga9i = desc:Samsung Display Corp. 0x4152,preferred,auto,2,transform,0 # petalburg

      monitor = ,preferred,auto,auto
      monitor = $framework
      monitor = $t440p
      monitor = $yoga9i
      monitor = desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2400x0,1.6 # workshop
      monitor = desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto
      monitor = desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto
      monitor = desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.25,vrr,2 # mauville

      # Turn off the internal display when lid is closed.
      bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"
      bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "$framework"
      bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "$t440p"
      bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "$yoga9i"

      # unscale XWayland apps
      xwayland {
        force_zero_scaling = true
      }

      # toolkit-specific scale
      env = GDK_SCALE,${gdk_scale}

      # Some default env vars.
      env = XCURSOR_SIZE,${toString config.alyraffauf.desktop.theme.cursorTheme.size}
      env = QT_QPA_PLATFORMTHEME,${qt_platform_theme}

      # Execute necessary apps
      ${
        if config.alyraffauf.desktop.hyprland.randomWallpaper
        then ""
        else "exec-once = ${wallpaperd}"
      }
      exec-once = ${bar}
      exec-once = ${fileManager} --daemon
      exec-once = ${idled}
      exec-once = ${lib.getExe' pkgs.blueman "blueman-applet"}
      exec-once = ${lib.getExe' pkgs.networkmanagerapplet "nm-applet"}
      exec-once = ${lib.getExe' pkgs.playerctl "playerctld"}
      exec-once = ${lib.getExe' pkgs.swayosd "swayosd-server"}
      exec-once = ${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${lib.getExe pkgs.cliphist} store
      exec-once = ${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${lib.getExe pkgs.cliphist} store
      exec-once = ${notifyd}
      exec-once = ${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us
          kb_variant = altgr-intl
          follow_mouse = 1
          sensitivity = 0 # -1.0 to 1.0, 0 means no modification.
          touchpad {
              clickfinger_behavior = true
              drag_lock = true
              middle_button_emulation = true
              natural_scroll = yes
              tap-to-click = true
          }
      }

      gestures {
          workspace_swipe = true
          workspace_swipe_touch = true
      }

      general {
          gaps_in = 5
          gaps_out = 7
          border_size = 2
          col.active_border = rgba(${lib.strings.removePrefix "#" config.alyraffauf.desktop.theme.colors.secondary}EE) rgba(${lib.strings.removePrefix "#" config.alyraffauf.desktop.theme.colors.primary}EE) 45deg
          col.inactive_border = rgba(${lib.strings.removePrefix "#" config.alyraffauf.desktop.theme.colors.inactive}AA)

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
          col.shadow = rgba(${lib.strings.removePrefix "#" config.alyraffauf.desktop.theme.colors.shadow}EE)

          dim_special = 0.5

          # Window-specific rules
          layerrule = blur, waybar
          layerrule = ignorezero, waybar
          layerrule = blur, launcher
          layerrule = blur, notifications
          layerrule = ignorezero, notifications
          layerrule = blur, logout_dialog
          layerrule = blur, swayosd
          layerrule = ignorezero, swayosd
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
          # no_gaps_when_only = 1
          preserve_split = yes # you probably want this
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      }

      master {
          always_center_master = true
          new_is_master = false
      }

      misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          focus_on_activate = true
          vfr = true
      }

      # Window Rules
      windowrulev2 = center(1),class:(.blueman-manager-wrapped)
      windowrulev2 = center(1),class:(blueberry.py)
      windowrulev2 = center(1),class:(com.github.wwmm.easyeffects)
      windowrulev2 = center(1),class:(nmtui)
      windowrulev2 = center(1),class:(org.keepassxc.KeePassXC)
      windowrulev2 = center(1),class:(pavucontrol)
      windowrulev2 = float, class:^(firefox)$, title:^(Picture-in-Picture)$
      windowrulev2 = float,class:(.blueman-manager-wrapped)
      windowrulev2 = float,class:(blueberry.py)
      windowrulev2 = float,class:(com.github.wwmm.easyeffects)
      windowrulev2 = float,class:(nmtui)
      windowrulev2 = float,class:(org.keepassxc.KeePassXC)
      windowrulev2 = float,class:(pavucontrol)
      windowrulev2 = move 70% 20%, class:^(firefox)$, title:^(Picture-in-Picture)$
      windowrulev2 = pin,   class:^(firefox)$, title:^(Picture-in-Picture)$
      windowrulev2 = size 40% 60%,class:(.blueman-manager-wrapped)
      windowrulev2 = size 40% 60%,class:(blueberry.py)
      windowrulev2 = size 40% 60%,class:(com.github.wwmm.easyeffects)
      windowrulev2 = size 40% 60%,class:(nmtui)
      windowrulev2 = size 40% 60%,class:(pavucontrol)
      windowrulev2 = size 80% 80%,class:(org.keepassxc.KeePassXC)
      windowrulev2 = suppressevent maximize, class:.*

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = ${modifier}, B, exec, ${browser}
      bind = ${modifier}, E, exec, ${editor}
      bind = ${modifier}, F, exec, ${fileManager}
      bind = ${modifier}, R, exec, ${launcher}
      bind = ${modifier}, T, exec, ${terminal}

      # Manage session.
      bind = ${modifier}, C, killactive,
      bind = ${modifier} CONTROL, L, exec, ${lock}
      bind = ${modifier}, M, exec, ${logout}

      # Basic window management.
      bind = ${modifier} SHIFT, W, fullscreen
      bind = ${modifier} SHIFT, V, togglefloating,
      # bind = ${modifier} SHIFT, P, pseudo, # dwindle
      bind = ${modifier} SHIFT, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = ${modifier}, left, movefocus, l
      bind = ${modifier}, right, movefocus, r
      bind = ${modifier}, up, movefocus, u
      bind = ${modifier}, down, movefocus, d

      # Move window with mainMod SHIFT + arrow keys
      bind = ${modifier} SHIFT, left, movewindow, l
      bind = ${modifier} SHIFT, right, movewindow, r
      bind = ${modifier} SHIFT, up, movewindow, u
      bind = ${modifier} SHIFT, down, movewindow, d

      # Gnome-like workspaces.
      bind = ${modifier}, comma, exec, ${hyprnome} --previous
      bind = ${modifier}, period, exec, ${hyprnome}
      bind = ${modifier} SHIFT, comma, exec, ${hyprnome} --previous --move
      bind = ${modifier} SHIFT, period, exec, ${hyprnome} --move

      # Switch workspaces with mainMod + [0-9]
      bind = ${modifier}, 1, workspace, 1
      bind = ${modifier}, 2, workspace, 2
      bind = ${modifier}, 3, workspace, 3
      bind = ${modifier}, 4, workspace, 4
      bind = ${modifier}, 5, workspace, 5
      bind = ${modifier}, 6, workspace, 6
      bind = ${modifier}, 7, workspace, 7
      bind = ${modifier}, 8, workspace, 8
      bind = ${modifier}, 9, workspace, 9
      bind = ${modifier}, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = ${modifier} SHIFT, 1, movetoworkspace, 1
      bind = ${modifier} SHIFT, 2, movetoworkspace, 2
      bind = ${modifier} SHIFT, 3, movetoworkspace, 3
      bind = ${modifier} SHIFT, 4, movetoworkspace, 4
      bind = ${modifier} SHIFT, 5, movetoworkspace, 5
      bind = ${modifier} SHIFT, 6, movetoworkspace, 6
      bind = ${modifier} SHIFT, 7, movetoworkspace, 7
      bind = ${modifier} SHIFT, 8, movetoworkspace, 8
      bind = ${modifier} SHIFT, 9, movetoworkspace, 9
      bind = ${modifier} SHIFT, 0, movetoworkspace, 10

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
      bindle = , xf86monbrightnessup, exec, ${brightness_up}
      bindle = , xf86monbrightnessdown, exec, ${brightness_down}
      bindle = , xf86audioraisevolume, exec, ${volume_up};
      bindle = , xf86audiolowervolume, exec, ${volume_down};
      bindl = , xf86audiomute, exec, ${volume_mute}
      bindl = , xf86audiomicmute, exec, ${mic_mute}
      bindl = , xf86audioplay, exec, ${media_play}
      bindl = , xf86audioprev, exec, ${media_prev}
      bindl = , xf86audionext, exec, ${media_next}

      # Extra bindings for petalburg.
      bind = , xf86launch4, exec, pp-adjuster
      bind = , xf86launch2, exec, ${media_play}

      # Screenshot with hyprshot.
      bind = , PRINT, exec, ${screenshot_screen}
      bind = ${modifier}, PRINT, exec, ${screenshot_region}

      # Show/hide waybar.
      bind = ${modifier}, F11, exec, pkill -SIGUSR1 waybar

      bind=CTRL ALT,R,submap,resize
      submap=resize
      binde=,right,resizeactive,10 0
      binde=,left,resizeactive,-10 0
      binde=,up,resizeactive,0 -10
      binde=,down,resizeactive,0 10
      bind=,escape,submap,reset
      submap=reset

      bind=CTRL ALT,M,submap,move
      submap=move
      # Move window with arrow keys
      bind = , left, movewindow, l
      bind = , right, movewindow, r
      bind = , up, movewindow, u
      bind = , down, movewindow, d
      # Move active window to a workspace with [0-9]
      bind = , 1, movetoworkspace, 1
      bind = , 2, movetoworkspace, 2
      bind = , 3, movetoworkspace, 3
      bind = , 4, movetoworkspace, 4
      bind = , 5, movetoworkspace, 5
      bind = , 6, movetoworkspace, 6
      bind = , 7, movetoworkspace, 7
      bind = , 8, movetoworkspace, 8
      bind = , 9, movetoworkspace, 9
      bind = , 0, movetoworkspace, 10
      # hyprnome
      bind = , comma, exec, ${hyprnome} --previous --move
      bind = , period, exec, ${hyprnome} --move
      bind=,escape,submap,reset
      submap=reset
    '';
  };
}
