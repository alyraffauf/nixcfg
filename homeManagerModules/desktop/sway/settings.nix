{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  scripts = import ./scripts.nix {inherit config lib pkgs;};
  helpers = import ../wayland/helpers.nix {inherit config lib pkgs;};
  modifier = "Mod4";
in {
  enable = true;
  wrapperFeatures.gtk = true;
  checkConfig = false;

  config = {
    bars = [{command = lib.getExe pkgs.waybar;}];
    modifier = modifier;
    colors.background = "${cfg.theme.colors.primary}EE";

    colors.focused = {
      background = "${cfg.theme.colors.primary}EE";
      border = "${cfg.theme.colors.primary}EE";
      childBorder = "${cfg.theme.colors.primary}EE";
      indicator = "${cfg.theme.colors.primary}EE";
      text = "${cfg.theme.colors.text}";
    };

    colors.focusedInactive = {
      background = "${cfg.theme.colors.inactive}AA";
      border = "${cfg.theme.colors.inactive}AA";
      childBorder = "${cfg.theme.colors.inactive}AA";
      indicator = "${cfg.theme.colors.inactive}AA";
      text = "${cfg.theme.colors.text}";
    };

    colors.unfocused = {
      background = "${cfg.theme.colors.inactive}AA";
      border = "${cfg.theme.colors.inactive}AA";
      childBorder = "${cfg.theme.colors.inactive}AA";
      indicator = "${cfg.theme.colors.inactive}AA";
      text = "${cfg.theme.colors.text}";
    };

    defaultWorkspace = "workspace number 1";

    focus = {
      followMouse = "always";
      newWindow = "focus";
      # mouseWarping = "container";
    };

    fonts = {
      names = ["${config.gtk.font.name}"];
      style = "Bold";
      size = config.gtk.font.size + 0.0;
    };

    gaps.inner = 5;
    gaps.outer = 5;

    input = {
      "type:touchpad" = {
        click_method = "clickfinger";
        dwt = "enabled";
        natural_scroll = "enabled";
        scroll_method = "two_finger";
        tap = "enabled";
        tap_button_map = "lrm";
      };

      "type:keyboard" = {
        xkb_layout = "us";
        xkb_variant = "altgr-intl";
      };

      "1386:21186:Wacom_HID_52C2_Finger" = {
        map_to_output = "'Samsung Display Corp. 0x4152 Unknown'";
      };

      "1386:21186:Wacom_HID_52C2_Pen" = {
        map_to_output = "'Samsung Display Corp. 0x4152 Unknown'";
      };
    };

    keybindings = {
      # Apps
      "${modifier}+B" = "exec ${lib.getExe cfg.defaultApps.webBrowser}";
      "${modifier}+E" = "exec ${lib.getExe cfg.defaultApps.editor}";
      "${modifier}+F" = "exec ${lib.getExe cfg.defaultApps.fileManager}";
      "${modifier}+R" = "exec ${lib.getExe pkgs.fuzzel}";
      "${modifier}+T" = "exec ${lib.getExe cfg.defaultApps.terminal}";

      # Manage session.
      "${modifier}+C" = "kill";
      "${modifier}+Control+L" = "exec ${lib.getExe pkgs.swaylock}";
      "${modifier}+M" = "exec ${lib.getExe pkgs.wlogout}";

      # Basic window management.
      "${modifier}+Shift+W" = "fullscreen toggle";
      "${modifier}+Shift+V" = "floating toggle";

      # Move focus with modifier + arrow keys
      "${modifier}+Left" = "focus left";
      "${modifier}+Down" = "focus down";
      "${modifier}+Up" = "focus up";
      "${modifier}+Right" = "focus right";

      # Move focus with modifier + hjkl keys (vim/ADM-3A terminal)
      "${modifier}+H" = "focus left";
      "${modifier}+J" = "focus down";
      "${modifier}+K" = "focus up";
      "${modifier}+L" = "focus right";

      # Move window with modifier SHIFT + arrow keys
      "${modifier}+Shift+Left" = "move left";
      "${modifier}+Shift+Down" = "move down";
      "${modifier}+Shift+Up" = "move up";
      "${modifier}+Shift+Right" = "move right";

      # Move window with modifier SHIFT + hjkl keys
      "${modifier}+Shift+H" = "move left";
      "${modifier}+Shift+J" = "move down";
      "${modifier}+Shift+K" = "move up";
      "${modifier}+Shift+L" = "move right";

      # Gnome-like workspaces.
      "${modifier}+Comma" = "workspace prev";
      "${modifier}+Period" = "workspace next";
      "${modifier}+Shift+Comma" = "move container to workspace prev; workspace prev";
      "${modifier}+Shift+Period" = "move container to workspace next; workspace next";

      # Switch workspaces with modifier + [0-9]
      "${modifier}+1" = "workspace number 1";
      "${modifier}+2" = "workspace number 2";
      "${modifier}+3" = "workspace number 3";
      "${modifier}+4" = "workspace number 4";
      "${modifier}+5" = "workspace number 5";
      "${modifier}+6" = "workspace number 6";
      "${modifier}+7" = "workspace number 7";
      "${modifier}+8" = "workspace number 8";
      "${modifier}+9" = "workspace number 9";
      "${modifier}+0" = "workspace number 10";

      # Move active window to a workspace with modifier + SHIFT + [0-9]
      "${modifier}+Shift+1" = "move container to workspace number 1; workspace 1";
      "${modifier}+Shift+2" = "move container to workspace number 2; workspace 2";
      "${modifier}+Shift+3" = "move container to workspace number 3; workspace 3";
      "${modifier}+Shift+4" = "move container to workspace number 4; workspace 4";
      "${modifier}+Shift+5" = "move container to workspace number 5; workspace 5";
      "${modifier}+Shift+6" = "move container to workspace number 6; workspace 6";
      "${modifier}+Shift+7" = "move container to workspace number 7; workspace 7";
      "${modifier}+Shift+8" = "move container to workspace number 8; workspace 8";
      "${modifier}+Shift+9" = "move container to workspace number 9; workspace 9";
      "${modifier}+Shift+0" = "move container to workspace number 10; workspace 10";

      # Move workspace to another output.
      "${modifier}+Control+Shift+Left" = "move workspace to output left";
      "${modifier}+Control+Shift+Down" = "move workspace to output down";
      "${modifier}+Control+Shift+Up" = "move workspace to output up";
      "${modifier}+Control+Shift+Right" = "move workspace to output right";

      # Move workspace to another output.
      "${modifier}+Control+Shift+H" = "move workspace to output left";
      "${modifier}+Control+Shift+J" = "move workspace to output down";
      "${modifier}+Control+Shift+K" = "move workspace to output up";
      "${modifier}+Control+Shift+L" = "move workspace to output right";

      # Scratchpad show and move
      "${modifier}+S" = "scratchpad show";
      "${modifier}+Shift+S" = "move scratchpad";

      # Screenshots
      "PRINT" = "exec ${helpers.screenshot.screen}";
      "${modifier}+PRINT" = "exec ${helpers.screenshot.region}";

      # Show/hide waybar
      "${modifier}+F11" = "exec pkill -SIGUSR1 waybar";

      "Ctrl+Mod1+M" = "mode move";
      "Ctrl+Mod1+R" = "mode resize";
    };

    modes = {
      move = {
        Escape = "mode default";
        Left = "move left";
        Down = "move down";
        Up = "move up";
        Right = "move right";
        H = "move left";
        J = "move down";
        K = "move up";
        L = "move right";
        Comma = "move container to workspace prev; workspace prev";
        Period = "move container to workspace next; workspace next";
        "1" = "move container to workspace number 1; workspace 1";
        "2" = "move container to workspace number 2; workspace 2";
        "3" = "move container to workspace number 3; workspace 3";
        "4" = "move container to workspace number 4; workspace 4";
        "5" = "move container to workspace number 5; workspace 5";
        "6" = "move container to workspace number 6; workspace 6";
        "7" = "move container to workspace number 7; workspace 7";
        "8" = "move container to workspace number 8; workspace 8";
        "9" = "move container to workspace number 9; workspace 9";
        "0" = "move container to workspace number 10; workspace 10";
        S = "move scratchpad";
      };

      resize = {
        Escape = "mode default";
        Left = "resize shrink width 10 px";
        Down = "resize grow height 10 px";
        Up = "resize shrink height 10 px";
        Right = "resize grow width 10 px";
      };
    };

    startup =
      [
        {
          command =
            if cfg.desktop.sway.randomWallpaper
            then "true"
            else "${lib.getExe pkgs.swaybg} -i ${cfg.theme.wallpaper}";
        }
        {command = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";}
        {command = "${scripts.idleD}";}
        {command = lib.getExe pkgs.autotiling;}
        {command = lib.getExe' pkgs.blueman "blueman-applet";}
        {command = lib.getExe' pkgs.networkmanagerapplet "nm-applet";}
        {command = lib.getExe' pkgs.playerctl "playerctld";}
        {command = lib.getExe' pkgs.swayosd "swayosd-server";}
        {command = lib.getExe pkgs.mako;}
      ]
      ++ lib.optional cfg.desktop.sway.redShift
      {command = "${lib.getExe pkgs.gammastep} -l 33.74:-84.38";};

    output = {
      "BOE 0x095F Unknown".scale = "1.5";
      "LG Display 0x0569 Unknown".scale = "1.0";
      "Samsung Display Corp. 0x4152 Unknown".scale = "2.0";
      "LG Electronics LG ULTRAWIDE 311NTAB5M720".scale = "1.25";

      "Guangxi Century Innovation Display Electronics Co., Ltd 27C1U-D 0000000000001" = {
        scale = "1.5";
        pos = "-2560 0";
      };

      "HP Inc. HP 24mh 3CM037248S   " = {
        scale = "1.0";
        pos = "-1920 0";
      };
    };

    floating.criteria = [
      {app_id = ".blueman-manager-wrapped";}
      {app_id = "Bitwarden";}
      {app_id = "blueberry.py";}
      {app_id = "com.github.wwmm.easyeffects";}
      {app_id = "org.keepassxc.KeePassXC";}
      {app_id = "pavucontrol";}
      {app_id = "solaar";}
      {title = "Open File";}
      {title = "Open Folder";}
      {window_role = "bubble";}
      {window_role = "dialog";}
      {window_role = "pop-up";}
      {window_type = "dialog";}
    ];

    window = {
      titlebar = false;
      commands = [
        {
          command = "floating enable; sticky toggle; resize 35ppt 10ppt";
          criteria = {
            title = "^Picture-in-Picture$";
            app_id = "firefox";
          };
        }
        {
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {title = "Open Folder";};
        }
        {
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {title = "Open File";};
        }
        {
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {app_id = "blueberry.py";};
        }
        {
          command = "resize set 60ppt 80ppt; move position center";
          criteria = {app_id = "solaar";};
        }
        {
          command = "resize set 80ppt 80ppt; move position center";
          criteria = {app_id = "org.keepassxc.KeePassXC";};
        }
        {
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {app_id = ".blueman-manager-wrapped";};
        }
        {
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {app_id = "pavucontrol";};
        }
      ];
    };

    workspaceAutoBackAndForth = true;
  };

  extraConfig = ''
    bindsym --locked XF86MonBrightnessUp exec ${helpers.brightness.up}
    bindsym --locked XF86MonBrightnessDown exec ${helpers.brightness.down}
    bindsym --locked XF86AudioRaiseVolume exec ${helpers.volume.up}
    bindsym --locked XF86AudioLowerVolume exec ${helpers.volume.down}
    bindsym --locked XF86AudioMute exec ${helpers.volume.mute}
    bindsym --locked XF86AudioMicMute exec ${helpers.volume.micMute}
    bindsym --locked XF86AudioPlay exec ${helpers.media.play}
    bindsym --locked XF86AudioPrev exec ${helpers.media.prev}
    bindsym --locked XF86AudioNext exec ${helpers.media.next}

    mode "move" {
      bindgesture swipe:right move container to workspace prev; workspace prev
      bindgesture swipe:left move container to workspace next; workspace next
      bindgesture pinch:inward+up move up
      bindgesture pinch:inward+down move down
      bindgesture pinch:inward+left move left
      bindgesture pinch:inward+right move right
    }

    bindgesture swipe:right workspace prev
    bindgesture swipe:left workspace next

    bindswitch --reload --locked lid:on output eDP-1 disable
    bindswitch --reload --locked lid:off output eDP-1 enable

    ${
      if config.wayland.windowManager.sway.package == pkgs.swayfx
      then "
        blur enable
        blur_passes 1

        corner_radius 10
        shadows enable
        shadows_on_csd enable
        shadow_color ${cfg.theme.colors.shadow}

        default_dim_inactive 0.05

        layer_effects launcher blur enable
        layer_effects launcher blur_ignore_transparent enable
        layer_effects logout_dialog blur enable
        layer_effects notifications blur enable
        layer_effects notifications blur_ignore_transparent enable
        layer_effects swaybar blur enable
        layer_effects swaybar blur_ignore_transparent enable
        layer_effects swayosd blur enable
        layer_effects swayosd blur_ignore_transparent enable
        layer_effects waybar blur enable
        layer_effects waybar blur_ignore_transparent enable"
      else ""
    }
  '';
}
