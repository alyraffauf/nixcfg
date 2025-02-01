{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
  scripts = import ./scripts.nix {inherit config lib pkgs;};
  helpers = import ./helpers.nix {inherit config lib pkgs;};
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
      ''$mod,M,exec,${lib.getExe config.programs.rofi.package} -show power-menu -modi "power-menu:${lib.getExe pkgs.rofi-power-menu} --choices=logout/lockscreen/suspend/shutdown/reboot"''
      ",PRINT,exec,${lib.getExe helpers.screenshot}"
      "$mod CTRL,L,exec,${lib.getExe' pkgs.systemd "loginctl"} lock-session"
      "$mod SHIFT,backslash,togglesplit"
      "$mod SHIFT,comma,exec,${lib.getExe pkgs.hyprnome} --previous --move"
      "$mod SHIFT,G,togglegroup"
      "$mod SHIFT,M,layoutmsg,swapwithmaster master"
      "$mod SHIFT,period,exec,${lib.getExe pkgs.hyprnome} --move"
      "$mod SHIFT,R,exec,${lib.getExe config.programs.rofi.package} -show run"
      "$mod SHIFT,S,movetoworkspace,special:magic"
      "$mod SHIFT,Tab,exec,${lib.getExe config.programs.rofi.package} -show window"
      "$mod SHIFT,V,togglefloating"
      "$mod SHIFT,W,fullscreen"
      "$mod,B,exec,${lib.getExe cfg.defaultApps.webBrowser}"
      "$mod,C,killactive"
      "$mod,comma,exec,${lib.getExe pkgs.hyprnome} --previous"
      "$mod,E,exec,${lib.getExe cfg.defaultApps.editor}"
      "$mod,F,exec,${lib.getExe cfg.defaultApps.fileManager}"
      "$mod,F11,exec,pkill -SIGUSR1 waybar"
      "$mod,H,changegroupactive,b"
      "$mod,L,changegroupactive,f"
      "$mod,Left,changegroupactive,b"
      "$mod,mouse_down,workspace,+1"
      "$mod,mouse_up,workspace,-1"
      "$mod,period,exec,${lib.getExe pkgs.hyprnome}"
      "$mod,R,exec,${lib.getExe config.programs.rofi.package} -show combi"
      "$mod,Right,changegroupactive,f"
      "$mod,S,togglespecialworkspace,magic"
      "$mod,T,exec,${lib.getExe cfg.defaultApps.terminal}"
      # "$mod,Tab,overview:toggle"
      "CTRL ALT,M,submap,move"
      "CTRL ALT,R,submap,resize"
      "CTRL,F12,exec,${lib.getExe helpers.screenshot}"
    ]
    ++ builtins.map (x: "$mod SHIFT,${toString x},movetoworkspace,${toString x}") [1 2 3 4 5 6 7 8 9]
    ++ builtins.map (x: "$mod,${toString x},workspace,${toString x}") [1 2 3 4 5 6 7 8 9]
    ++ lib.attrsets.mapAttrsToList (key: direction: "$mod CTRL SHIFT,${key},movecurrentworkspacetomonitor,${builtins.substring 0 1 direction}") cfg.desktop.windowManagerBinds
    ++ lib.attrsets.mapAttrsToList (key: direction: "$mod SHIFT,${key},movewindow,${builtins.substring 0 1 direction}") cfg.desktop.windowManagerBinds
    ++ lib.attrsets.mapAttrsToList (key: direction: "$mod,${key},movefocus,${builtins.substring 0 1 direction}") cfg.desktop.windowManagerBinds;

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
    ++ builtins.map (switch: ",switch:${switch},exec,${scripts.tablet}") cfg.desktop.hyprland.tabletMode.switches
    ++ lib.lists.optionals (cfg.desktop.hyprland.laptopMonitor != null)
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
      passes = 2;
      popups = true;
      size = 8;
    };

    dim_special = 0.5;

    layerrule = [
      "blur,gtk-layer-shell"
      "blur,launcher"
      "blur,logout_dialog"
      "blur,notifications"
      "blur,nwg-drawer"
      "blur,rofi"
      "blur,swayosd"
      "blur,waybar"
      "ignorezero,gtk-layer-shell"
      "ignorezero,notifications"
      "ignorezero,nwg-drawer"
      "ignorezero,rofi"
      "ignorezero,swayosd"
      "ignorezero,waybar"
    ];

    rounding = 10;

    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
    };
  };

  dwindle.preserve_split = true;

  env = [
    "QT_QPA_PLATFORMTHEME,kde"
    "QT_STYLE_OVERRIDE,Breeze"
  ];

  input = {
    focus_on_close = 1;
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
    allow_tearing = false;
    border_size = 4;
    gaps_in = 5;
    gaps_out = 6;
    layout = "dwindle";
    "col.active_border" = lib.mkForce "rgb(${config.lib.stylix.colors.base0D}) rgb(${config.lib.stylix.colors.base0E}) 45deg";
  };

  gestures = {
    workspace_swipe = true;
    workspace_swipe_touch = true;
  };

  group = {
    "col.border_active" = lib.mkForce "rgb(${config.lib.stylix.colors.base0D}) rgb(${config.lib.stylix.colors.base0E}) 45deg";

    groupbar = {
      height = 24;
      text_color = lib.mkForce "rgb(${config.lib.stylix.colors.base00})";
      font_size = config.stylix.fonts.sizes.desktop;
      "col.active" = lib.mkForce "rgb(${config.lib.stylix.colors.base0E})";
    };
  };

  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    enable_swallow = true;
    focus_on_activate = true;
    font_family = config.stylix.fonts.sansSerif.name;
    key_press_enables_dpms = true;
    mouse_move_enables_dpms = true;
    swallow_regex = "^(Alacritty|kitty|footclient|foot|com\.mitchellh\.ghostty|org\.wezfurlong\.wezterm)$";
    vfr = true;
  };

  monitor =
    [",preferred,auto,auto"]
    ++ [cfg.desktop.hyprland.laptopMonitor]
    ++ cfg.desktop.hyprland.monitors;

  # plugin = {
  #   overview = {
  #     exitOnSwitch = true;
  #     gaps_in = 5;
  #     gaps_out = 6;
  #     onBottom = true;
  #     overrideGaps = true;
  #     showEmptyWorkspace = true;
  #     showNewWorkspace = true;
  #     workspaceActiveBorder = "rgb(${config.lib.stylix.colors.base0D})";
  #     workspaceBorderSize = 4;
  #     workspaceInactiveBorder = "rgb(${config.lib.stylix.colors.base03})";
  #     workspaceMargin = 40;
  #   };
  # };

  windowrulev2 = [
    "center(1),class:(.blueman-manager-wrapped)"
    "center(1),class:(Bitwarden)"
    "center(1),class:(blueberry.py)"
    "center(1),class:(com.github.wwmm.easyeffects)"
    "center(1),class:(gcr-prompter)"
    "center(1),class:(nm-connection-editor)"
    "center(1),class:(org.keepassxc.KeePassXC)"
    "center(1),class:(pavucontrol)"
    "center(1),class:(polkit-gnome-authentication-agent-1)"
    "center(1),initialTitle:(File Operation Progress)"
    "float,class:(.blueman-manager-wrapped)"
    "float,class:(Bitwarden)"
    "float,class:(blueberry.py)"
    "float,class:(com.github.wwmm.easyeffects)"
    "float,class:(nm-connection-editor)"
    "float,class:(org.keepassxc.KeePassXC)"
    "float,class:(pavucontrol)"
    "float,class:^(firefox)$, title:^(Picture-in-Picture)$"
    "float,initialTitle:(File Operation Progress)"
    "move 70% 20%, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "pin,class:(gcr-prompter)"
    "pin,class:(polkit-gnome-authentication-agent-1)"
    "pin,class:^(firefox)$, title:^(Picture-in-Picture)$"
    "size 40% 20%,initialTitle:(File Operation Progress)"
    "size 40% 60%,class:(.blueman-manager-wrapped)"
    "size 40% 60%,class:(blueberry.py)"
    "size 40% 60%,class:(com.github.wwmm.easyeffects)"
    "size 40% 60%,class:(nm-connection-editor)"
    "size 40% 60%,class:(pavucontrol)"
    "size 80% 80%,class:(Bitwarden)"
    "size 80% 80%,class:(org.keepassxc.KeePassXC)"
    "stayfocused,class:(gcr-prompter)"
    "stayfocused,class:(polkit-gnome-authentication-agent-1)"
    "suppressevent maximize, class:.*"
  ];

  xwayland.force_zero_scaling = true;
}
