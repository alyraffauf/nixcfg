{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  helpers = import ../wayland/helpers.nix {inherit config lib pkgs;};
  modifier = "Mod4";
in {
  enable = true;
  checkConfig = false;
  package = lib.mkDefault pkgs.swayfx;
  wrapperFeatures.gtk = true;

  config = {
    bars = [];
    modifier = modifier;

    colors = {
      background = "${cfg.theme.colors.primary}EE";

      focused = {
        background = "${cfg.theme.colors.primary}EE";
        border = "${cfg.theme.colors.primary}EE";
        childBorder = "${cfg.theme.colors.primary}EE";
        indicator = "${cfg.theme.colors.primary}EE";
        text = "${cfg.theme.colors.text}";
      };

      focusedInactive = {
        background = "${cfg.theme.colors.inactive}AA";
        border = "${cfg.theme.colors.inactive}AA";
        childBorder = "${cfg.theme.colors.inactive}AA";
        indicator = "${cfg.theme.colors.inactive}AA";
        text = "${cfg.theme.colors.text}";
      };

      unfocused = {
        background = "${cfg.theme.colors.inactive}AA";
        border = "${cfg.theme.colors.inactive}AA";
        childBorder = "${cfg.theme.colors.inactive}AA";
        indicator = "${cfg.theme.colors.inactive}AA";
        text = "${cfg.theme.colors.text}";
      };
    };

    defaultWorkspace = "workspace number 1";

    focus = {
      followMouse = "always";
      newWindow = "focus";
    };

    fonts = {
      names = ["${config.gtk.font.name}"];
      style = "Bold";
      size = config.gtk.font.size + 0.0;
    };

    gaps = {
      inner = 5;
      outer = 5;
    };

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
        xkb_options = "caps:ctrl_modifier";
      };
    };

    keybindings =
      {
        "${modifier}+B" = "exec ${lib.getExe cfg.defaultApps.webBrowser}";
        "${modifier}+C" = "kill";
        "${modifier}+Comma" = "workspace prev";
        "${modifier}+Control+L" = "exec ${lib.getExe pkgs.swaylock}";
        "${modifier}+E" = "exec ${lib.getExe cfg.defaultApps.editor}";
        "${modifier}+F" = "exec ${lib.getExe cfg.defaultApps.fileManager}";
        "${modifier}+F11" = "exec pkill -SIGUSR1 waybar"; # Show/hide waybar
        "${modifier}+M" = ''exec ${lib.getExe config.programs.rofi.package} -show power-menu -modi "power-menu:${lib.getExe pkgs.rofi-power-menu} --choices=logout/lockscreen/suspend/shutdown/reboot"'';
        "${modifier}+Period" = "workspace next";
        "${modifier}+R" = "exec ${lib.getExe config.programs.rofi.package} -show combi";
        "${modifier}+S" = "scratchpad show";
        "${modifier}+Shift+Comma" = "move container to workspace prev; workspace prev";
        "${modifier}+Shift+Period" = "move container to workspace next; workspace next";
        "${modifier}+Shift+R" = "exec ${lib.getExe config.programs.rofi.package} -show run";
        "${modifier}+Shift+S" = "move scratchpad";
        "${modifier}+Shift+V" = "floating toggle";
        "${modifier}+Shift+W" = "fullscreen toggle";
        "${modifier}+T" = "exec ${lib.getExe cfg.defaultApps.terminal}";
        "${modifier}+Tab" = "exec ${lib.getExe config.programs.rofi.package} -show window";
        "Control+F12" = "exec ${helpers.screenshot}";
        "Ctrl+Mod1+M" = "mode move";
        "Ctrl+Mod1+R" = "mode resize";
        "PRINT" = "exec ${helpers.screenshot}";
      }
      // builtins.listToAttrs (
        builtins.concatMap (workspace: [
          {
            name = "${modifier}+${toString workspace}";
            value = "workspace number ${toString workspace}";
          }
          {
            name = "${modifier}+Shift+${toString workspace}";
            value = "move container to workspace number ${toString workspace}; workspace ${toString workspace}";
          }
        ]) [1 2 3 4 5 6 7 8 9]
      )
      // lib.attrsets.concatMapAttrs
      (key: direction: {
        "${modifier}+${key}" = "focus ${direction}";
        "${modifier}+Shift+${key}" = "move ${direction}";
        "${modifier}+Control+Shift+${key}" = "move workspace to output ${direction}";
      })
      cfg.desktop.sway.windowManagerBinds;

    modes = {
      move =
        {
          Comma = "move container to workspace prev; workspace prev";
          Escape = "mode default";
          Period = "move container to workspace next; workspace next";
          S = "move scratchpad";
        }
        // builtins.listToAttrs (
          builtins.concatMap (workspace: [
            {
              name = toString workspace;
              value = "move container to workspace number ${toString workspace}; workspace ${toString workspace}";
            }
          ]) [1 2 3 4 5 6 7 8 9]
        )
        // lib.attrsets.concatMapAttrs
        (key: direction: {"${key}" = "move ${direction}";})
        cfg.desktop.sway.windowManagerBinds;

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
        {command = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";}
        {command = lib.getExe pkgs.autotiling;}
      ]
      ++ lib.optional cfg.desktop.randomWallpaper {command = "${helpers.wallpaperD}";}
      ++ lib.optional (!cfg.desktop.randomWallpaper) {command = "${lib.getExe pkgs.swaybg} -i ${cfg.theme.wallpaper}";};

    floating.criteria = [
      {app_id = ".blueman-manager-wrapped";}
      {app_id = "blueberry.py";}
      {app_id = "com.github.wwmm.easyeffects";}
      {app_id = "nm-connection-editor";}
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
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {app_id = ".blueman-manager-wrapped";};
        }
        {
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {app_id = "nm-connection-editor";};
        }
        {
          command = "resize set 40ppt 60ppt; move position center";
          criteria = {app_id = "pavucontrol";};
        }
      ];
    };

    workspaceAutoBackAndForth = true;
  };

  extraConfig =
    ''
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
    ''
    + lib.strings.optionalString (config.wayland.windowManager.sway.package
      == pkgs.swayfx) ''
      blur enable
      blur_passes 1

      # corner_radius 10
      shadows enable
      shadows_on_csd enable
      shadow_color ${cfg.theme.colors.shadow}

      default_dim_inactive 0.05

      layer_effects gtk-layer-shell blur enable
      layer_effects gtk-layer-shell blur_ignore_transparent enable
      layer_effects launcher blur enable
      layer_effects launcher blur_ignore_transparent enable
      layer_effects logout_dialog blur enable
      layer_effects notifications blur enable
      layer_effects notifications blur_ignore_transparent enable
      layer_effects rofi blur enable
      layer_effects rofi blur_ignore_transparent enable
      layer_effects swaybar blur enable
      layer_effects swaybar blur_ignore_transparent enable
      layer_effects swayosd blur enable
      layer_effects swayosd blur_ignore_transparent enable
      layer_effects waybar blur enable
      layer_effects waybar blur_ignore_transparent enable
    '';
}
