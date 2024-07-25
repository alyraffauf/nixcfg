{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  scripts = import ./scripts.nix {inherit config lib pkgs;};
  helpers = import ../wayland/helpers.nix {inherit config lib pkgs;};
in {
  "$mod" = "SUPER";

  animations = {
    enabled = true;
    bezier = "myBezier,0.05,0.9,0.1,1.05";

    animation = [
      "border,1,10,default"
      "borderangle,1,8,default"
      "fade,1,7,default"
      "specialWorkspace,1,6,default,slidevert"
      "windows,1,7,myBezier"
      "windowsOut,1,7,default,popin 80%"
      "workspaces,1,6,default"
    ];
  };

  bind =
    [
      "$mod CONTROL,L,exec,${lib.getExe pkgs.swaylock}"
      "$mod SHIFT,S,movetoworkspace,special:magic"
      "$mod SHIFT,V,togglefloating"
      "$mod SHIFT,W,fullscreen"
      "$mod SHIFT,backslash,togglesplit"
      "$mod SHIFT,comma,exec,${lib.getExe pkgs.hyprnome} --previous --move"
      "$mod SHIFT,period,exec,${lib.getExe pkgs.hyprnome} --move"
      "$mod,B,exec,${lib.getExe cfg.defaultApps.webBrowser}"
      "$mod,C,killactive"
      "$mod,E,exec,${lib.getExe cfg.defaultApps.editor}"
      "$mod,F,exec,${lib.getExe cfg.defaultApps.fileManager}"
      "$mod,F11,exec,pkill -SIGUSR1 waybar"
      "$mod,M,exec,${lib.getExe pkgs.wlogout}"
      "$mod,R,exec,${lib.getExe pkgs.fuzzel}"
      "$mod,S,togglespecialworkspace,magic"
      "$mod,T,exec,${lib.getExe cfg.defaultApps.terminal}"
      "$mod,comma,exec,${lib.getExe pkgs.hyprnome} --previous"
      "$mod,mouse_down,workspace,+1"
      "$mod,mouse_up,workspace,-1"
      "$mod,period,exec,${lib.getExe pkgs.hyprnome}"
      ",PRINT,exec,${helpers.screenshot}"
      "CONTROL,F12,exec,${helpers.screenshot}"
      "CTRL ALT,M,submap,move"
      "CTRL ALT,R,submap,resize"
    ]
    ++ builtins.map (x: "$mod SHIFT,${toString x},movetoworkspace,${toString x}") [1 2 3 4 5 6 7 8 9]
    ++ builtins.map (x: "$mod,${toString x},workspace,${toString x}") [1 2 3 4 5 6 7 8 9]
    ++ lib.attrsets.mapAttrsToList (key: direction: "$mod CONTROL SHIFT,${key},movecurrentworkspacetomonitor,${direction}") cfg.desktop.hyprland.windowManagerBinds
    ++ lib.attrsets.mapAttrsToList (key: direction: "$mod SHIFT,${key},movewindow,${direction}") cfg.desktop.hyprland.windowManagerBinds
    ++ lib.attrsets.mapAttrsToList (key: direction: "$mod,${key},movefocus,${direction}") cfg.desktop.hyprland.windowManagerBinds;

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging
    "$mod,mouse:272,movewindow"
    "$mod,mouse:273,resizewindow"
  ];

  bindl =
    [
      # Volume, microphone, and media keys.
      ",xf86audiomute,exec,${helpers.volume.mute}"
      ",xf86audiomicmute,exec,${helpers.volume.micMute}"
      ",xf86audioplay,exec,${helpers.media.play}"
      ",xf86audioprev,exec,${helpers.media.prev}"
      ",xf86audionext,exec,${helpers.media.next}"
    ]
    ++ builtins.map (switch: ",switch:${switch},exec,${scripts.tablet}") cfg.desktop.hyprland.tabletMode.tabletSwitches
    ++ lib.lists.optionals (cfg.desktop.hyprland.laptopMonitors != [])
    [
      ",switch:on:Lid Switch,exec,${scripts.clamshell} on"
      ",switch:off:Lid Switch,exec,${scripts.clamshell} off"
    ];

  bindle = [
    # Display, volume, microphone, and media keys.
    ",xf86monbrightnessup,exec,${helpers.brightness.up}"
    ",xf86monbrightnessdown,exec,${helpers.brightness.down}"
    ",xf86audioraisevolume,exec,${helpers.volume.up}"
    ",xf86audiolowervolume,exec,${helpers.volume.down}"
  ];

  decoration = {
    blur = {
      enabled = true;
      passes = 1;
      size = 8;
    };

    "col.shadow" = "rgba(${lib.strings.removePrefix "#" cfg.theme.colors.shadow}EE)";
    dim_special = 0.5;
    drop_shadow = true;

    layerrule = [
      "blur,launcher"
      "blur,logout_dialog"
      "blur,notifications"
      "blur,rofi"
      "blur,swayosd"
      "blur,waybar"
      "ignorezero,notifications"
      "ignorezero,swayosd"
      "ignorezero,waybar"
    ];

    rounding = 10;
    shadow_range = 4;
    shadow_render_power = 3;
  };

  dwindle.preserve_split = true;

  exec-once =
    [
      scripts.wallpaperD
      (lib.getExe pkgs.waybar)
      scripts.idleD
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
    follow_mouse = 1;
    kb_layout = "us";
    kb_variant = "altgr-intl";
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
    "col.active_border" = "rgba(${lib.strings.removePrefix "#" cfg.theme.colors.secondary}EE) rgba(${lib.strings.removePrefix "#" cfg.theme.colors.primary}EE) 45deg";
    "col.inactive_border" = "rgba(${lib.strings.removePrefix "#" cfg.theme.colors.inactive}AA)";
    allow_tearing = false;
    border_size = 2;
    gaps_in = 5;
    gaps_out = 6;
    layout = "dwindle";
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

  monitor =
    [",preferred,auto,auto"]
    ++ cfg.desktop.hyprland.laptopMonitors
    ++ cfg.desktop.hyprland.monitors;

  windowrulev2 = [
    "center(1),class:(.blueman-manager-wrapped)"
    "center(1),class:(com.github.wwmm.easyeffects)"
    "center(1),class:(pavucontrol)"
    "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "float,class:(.blueman-manager-wrapped)"
    "float,class:(com.github.wwmm.easyeffects)"
    "float,class:(pavucontrol)"
    "move 70% 20%, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "pin,class:^(firefox)$, title:^(Picture-in-Picture)$"
    "size 40% 60%,class:(.blueman-manager-wrapped)"
    "size 40% 60%,class:(com.github.wwmm.easyeffects)"
    "size 40% 60%,class:(pavucontrol)"
    "suppressevent maximize, class:.*"
  ];

  xwayland.force_zero_scaling = true;
}
