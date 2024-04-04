{ pkgs, lib, config, ... }: {

  imports = [ ./hypridle ./hyprlock ./hyprpaper ./hyprshade ./theme.nix ];

  options = {
    desktopEnv.hyprland.enable =
      lib.mkEnableOption "Enables hyprland with extra apps.";
  };

  config = lib.mkIf config.desktopEnv.hyprland.enable {

    # Hypr* modules, plguins, and tools.
    desktopEnv.hyprland.hypridle.enable = lib.mkDefault true;
    desktopEnv.hyprland.hyprlock.enable = lib.mkDefault true;
    desktopEnv.hyprland.hyprpaper.enable = lib.mkDefault true;
    desktopEnv.hyprland.hyprshade.enable = lib.mkDefault true;

    desktopEnv.hyprland.theme.enable = lib.mkDefault true;

    # Basic apps needed to run a hyprland desktop.
    guiApps.waybar.enable = lib.mkDefault true;
    guiApps.mako.enable = lib.mkDefault true;
    guiApps.fuzzel.enable = lib.mkDefault true;
    guiApps.wlogout.enable = lib.mkDefault true;
    guiApps.alacritty.enable = lib.mkDefault true;
    guiApps.firefox.enable = lib.mkDefault true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      brightnessctl
      evince
      hyprcursor
      hyprland-protocols
      hyprnome
      hyprshot
      playerctl
      xfce.exo
      xfce.ristretto
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfce4-settings
      xfce.xfce4-taskmanager
      xfce.xfconf
    ];

    services.cliphist.enable = lib.mkDefault true;

    xdg.configFile."xfce4/helpers.rc".text = ''
      TerminalEmulator=alacritty
      FileManager=thunar
      WebBrowser=firefox
    '';

    xdg.portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.extraConfig = let
      modifier = "SUPER";

      # Default apps
      browser = pkgs.firefox + "/bin/firefox";
      fileManager = pkgs.xfce.thunar + "/bin/thunar";
      editor = pkgs.vscodium + "/bin/codium";
      terminal = pkgs.alacritty + "/bin/alacritty";

      # Hyprland desktop utilities
      bar = pkgs.waybar + "/bin/waybar";
      launcher = pkgs.fuzzel + "/bin/fuzzel";
      notifyd = pkgs.mako + "/bin/mako";
      wallpaperd = pkgs.hyprpaper + "/bin/hyprpaper";
      idle = pkgs.hypridle + "/bin/hypridle";
      logout = pkgs.wlogout + "/bin/wlogout";
      lock = pkgs.hyprlock + "/bin/hyprlock --immediate";
      hyprnome = pkgs.hyprnome + "/bin/hyprnome";
      hyprshade = pkgs.hyprshade + "/bin/hyprshade";

      # Media/hardware commands
      brightness = "${pkgs.brightnessctl}/bin/brightnessctl";
      brightness_up = "${brightness} set 5%+";
      brightness_down = "${brightness} set 5%-";
      volume = "${pkgs.wireplumber}/bin/wpctl";
      volume_up = "${volume} set-volume -l 1.0 @DEFAULT_SINK@ 5%+";
      volume_down = "${volume} set-volume -l 1.0 @DEFAULT_SINK@ 5%-";
      volume_mute = "${volume} set-mute @DEFAULT_SINK@ toggle";
      mic_mute = "${volume} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      media = "${pkgs.playerctl}/bin/playerctl";
      media_play = "${media} play-pause";
      media_next = "${media} next";
      media_previous = "${media} previous";

      screenshot = "${pkgs.hyprshot}/bin/hyprshot";
      screenshot_folder = "~/pics/screenshots";
      screenshot_screen = "${screenshot} -m output -o ${screenshot_folder}";

      # Color, themes, scaling
      border_primary = "ca9ee6ee";
      border_secondary = "99d1dbee";
      border_inactive = "303446aa";
      drop_shadow = "1a1a1aee";
      cursor_size = "24";
      qt_platform_theme = "gtk2";
      gdk_scale = "1.5";

    in ''
    monitor = desc:BOE 0x0BCA,preferred,auto,1.566667 # lavaridge fw13 matte display
    monitor = desc:BOE 0x095F,preferred,auto,1.566667# lavaridge fw13 glossy display
    monitor = desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.25,vrr,2 # mauville
    monitor = desc:LG Display 0x0569,preferred,auto,1.2 # rustboro
    monitor = desc:Samsung Display Corp. 0x4152,preferred,auto,2 # petalburg
    monitor = desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2560x0,1.5 # workshop
    monitor=,preferred,auto,auto

    # unscale XWayland apps
    xwayland {
      force_zero_scaling = true
    }

    # toolkit-specific scale
    env = GDK_SCALE,${gdk_scale}

    # Some default env vars.
    env = XCURSOR_SIZE,${cursor_size}
    env = QT_QPA_PLATFORMTHEME,${qt_platform_theme}

    # Execute necessary apps
    exec-once = ${pkgs.hyprshade}/bin/hyprshade auto
    exec-once = ${pkgs.hypridle}/bin/hypridle
    exec-once = ${wallpaperd}
    exec-once = ${bar}
    exec-once = ${notifyd}
    exec-once = ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store
    exec-once = ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store

    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    input {
        kb_layout = us
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
    }

    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(${border_secondary}) rgba(${border_primary}) 45deg
        col.inactive_border = rgba(${border_inactive})

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
        col.shadow = rgba(${drop_shadow})

        dim_special = 0.5

        # Window-specific rules
        layerrule = blur, waybar
        layerrule = ignorezero, waybar
        layerrule = blur, launcher
        layerrule = blur, notifications
        layerrule = ignorezero, notifications
        layerrule = blur, logout_dialog
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
    windowrulev2 = center(1),class:(blueberry.py)
    windowrulev2 = center(1),class:(nmtui)
    windowrulev2 = center(1),class:(pavucontrol)
    windowrulev2 = float,class:(blueberry.py)
    windowrulev2 = float,class:(nmtui)
    windowrulev2 = float,class:(pavucontrol)
    windowrulev2 = suppressevent maximize, class:.*

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = ${modifier}, T, exec, ${terminal}
    bind = ${modifier}, F, exec, ${fileManager}
    bind = ${modifier}, B, exec, ${browser}
    bind = ${modifier}, E, exec, ${editor}
    bind = ${modifier}, R, exec, ${launcher}

    # Manage session.
    bind = ${modifier}, C, killactive, 
    bind = ${modifier}, M, exec, ${logout}
    bind = ${modifier}, L, exec, ${lock}

    # Basic window management.
    bind = ${modifier} SHIFT, W, fullscreen
    bind = ${modifier} SHIFT, V, togglefloating, 
    bind = ${modifier} SHIFT, P, pseudo, # dwindle
    bind = ${modifier} SHIFT, J, togglesplit, # dwindle

    # Move focus with mainMod + arrow keys
    bind = ${modifier}, left, movefocus, l
    bind = ${modifier}, right, movefocus, r
    bind = ${modifier}, up, movefocus, u
    bind = ${modifier}, down, movefocus, d

    # Gnome-like workspaces.
    bind = ${modifier}, 1, exec, ${hyprnome} --previous
    bind = ${modifier}, 2, exec, ${hyprnome}
    bind = ${modifier} SHIFT, 1, exec, ${hyprnome} --previous --move
    bind = ${modifier} SHIFT, 2, exec, ${hyprnome} --move

    # # Switch workspaces with mainMod + [0-9]
    # bind = ${modifier}, 1, workspace, 1
    # bind = ${modifier}, 2, workspace, 2
    # bind = ${modifier}, 3, workspace, 3
    # bind = ${modifier}, 4, workspace, 4
    # bind = ${modifier}, 5, workspace, 5
    # bind = ${modifier}, 6, workspace, 6
    # bind = ${modifier}, 7, workspace, 7
    # bind = ${modifier}, 8, workspace, 8
    # bind = ${modifier}, 9, workspace, 9
    # bind = ${modifier}, 0, workspace, 10

    # # Move active window to a workspace with mainMod + SHIFT + [0-9]
    # bind = ${modifier} SHIFT, 1, movetoworkspace, 1
    # bind = ${modifier} SHIFT, 2, movetoworkspace, 2
    # bind = ${modifier} SHIFT, 3, movetoworkspace, 3
    # bind = ${modifier} SHIFT, 4, movetoworkspace, 4
    # bind = ${modifier} SHIFT, 5, movetoworkspace, 5
    # bind = ${modifier} SHIFT, 6, movetoworkspace, 6
    # bind = ${modifier} SHIFT, 7, movetoworkspace, 7
    # bind = ${modifier} SHIFT, 8, movetoworkspace, 8
    # bind = ${modifier} SHIFT, 9, movetoworkspace, 9
    # bind = ${modifier} SHIFT, 0, movetoworkspace, 10

    # Example special workspace (scratchpad)
    bind = ${modifier}, S, togglespecialworkspace, magic
    bind = ${modifier} SHIFT, S, movetoworkspace, special:magic

    # Scroll through existing workspaces with mainMod + scroll
    bind = ${modifier}, mouse_down, workspace, e+1
    bind = ${modifier}, mouse_up, workspace, e-1

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
    bindl = , xf86audioprev, exec, ${media_previous}
    bindl = , xf86audionext, exec, ${media_next}

    # Extra bindings for petalburg.
    bind = , xf86launch4, exec, pp-adjuster
    bind = , xf86launch1, exec, ${pkgs.hyprshade}/bin/hyprshade toggle
    bind = , xf86launch2, exec, ${media_play}

    # Screenshot with hyprshot.
    bind = , PRINT, exec, ${screenshot_screen}

    # Show/hide waybar.
    bind = ${modifier}, F11, exec, pkill -SIGUSR1 waybar
    '';

  };
}
