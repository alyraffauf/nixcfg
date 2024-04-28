{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  imports = [./randomWallpaper.nix];
  options = {
    alyraffauf.desktop.sway.enable = lib.mkEnableOption "Sway with extra apps.";
    alyraffauf.desktop.sway.autoSuspend = lib.mkOption {
      description = "Whether to autosuspend on idle.";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.sway.enable {
    alyraffauf = {
      apps = {
        alacritty.enable = lib.mkDefault true;
        firefox.enable = lib.mkDefault true;
        fuzzel.enable = lib.mkDefault true;
        kanshi.enable = lib.mkDefault true;
        mako.enable = lib.mkDefault true;
        swaylock.enable = lib.mkDefault true;
        thunar.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
        wlogout.enable = lib.mkDefault true;
      };
      desktop.theme.enable = lib.mkDefault true;
    };
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      celluloid
      evince
      gnome.eog
      gnome.file-roller
      networkmanagerapplet
      playerctl
      swayidle
      swayosd
      xfce.xfce4-taskmanager
    ];

    programs.swaylock.enable = lib.mkDefault true;

    services.cliphist.enable = lib.mkDefault true;

    programs.waybar = {
      settings = {
        mainBar = {
          modules-left = ["sway/workspaces" "sway/mode"];
        };
      };
    };

    xdg.configFile."waybar/sway-style.css".source = ./waybar.css;

    wayland.windowManager.sway.enable = true;
    wayland.windowManager.sway.package = pkgs.swayfx;
    wayland.windowManager.sway.wrapperFeatures.gtk = true;
    wayland.windowManager.sway.config = let
      modifier = "Mod4";

      # Default apps
      browser = pkgs.firefox + "/bin/firefox";
      fileManager = pkgs.xfce.thunar + "/bin/thunar";
      editor = pkgs.vscodium + "/bin/codium";
      terminal = pkgs.alacritty + "/bin/alacritty";

      brightness = "${pkgs.swayosd}/bin/swayosd-client";
      brightness_up = "${brightness} --brightness=raise";
      brightness_down = "${brightness} --brightness=lower";
      volume = "${pkgs.swayosd}/bin/swayosd-client";
      volume_up = "${volume} --output-volume=raise";
      volume_down = "${volume} --output-volume=lower";
      volume_mute = "${volume} --output-volume=mute-toggle";
      mic_mute = "${volume} --input-volume=mute-toggle";
      media = "${pkgs.playerctl}/bin/playerctl";
      media_play = "${media} play-pause";
      media_next = "${media} next";
      media_prev = "${media} previous";

      # Sway desktop utilities
      bar = pkgs.waybar + "/bin/waybar -s ${config.xdg.configHome}/waybar/sway-style.css";
      launcher = pkgs.fuzzel + "/bin/fuzzel";
      notifyd = pkgs.mako + "/bin/mako";
      wallpaperd = pkgs.swaybg + "/bin/swaybg -i ${config.xdg.dataHome}/backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg";
      logout = pkgs.wlogout + "/bin/wlogout";
      lock = pkgs.swaylock + ''/bin/swaylock'';
      idled =
        if config.alyraffauf.desktop.sway.autoSuspend
        then ''
          ${pkgs.swayidle}/bin/swayidle -w \
                  timeout 240 '${pkgs.brightnessctl}/bin/brightnessctl -s set 10' \
                    resume '${pkgs.brightnessctl}/bin/brightnessctl -r' \
                  timeout 300 '${lock}' \
                  timeout 330 '${config.wayland.windowManager.sway.package}/bin/swaymsg "output * dpms off"' \
                    resume '${config.wayland.windowManager.sway.package}/bin/swaymsg "output * dpms on"' \
                  timeout 900 '${pkgs.systemd}/bin/systemctl suspend' \
                  before-sleep '${media} pause' \
                  before-sleep '${lock}'
        ''
        else ''
          ${pkgs.swayidle}/bin/swayidle -w \
                  timeout 240 '${pkgs.brightnessctl}/bin/brightnessctl -s set 10' \
                    resume '${pkgs.brightnessctl}/bin/brightnessctl -r' \
                  timeout 300 '${lock}' \
                  timeout 330 '${config.wayland.windowManager.sway.package}/bin/swaymsg "output * dpms off"' \
                    resume '${config.wayland.windowManager.sway.package}/bin/swaymsg "output * dpms on"' \
                  before-sleep '${media} pause' \
                  before-sleep '${lock}'
        '';

      screenshot = "${pkgs.shotman}/bin/shotman";
      # screenshot_folder = "~/pics/screenshots";
      # screenshot_screen = "${screenshot} ${screenshot_folder}/$(date +'%s_grim.png')";
      # screenshot_region = "${screenshot} -m region -o ${screenshot_folder}";
      screenshot_screen = "${screenshot} --capture output";
      screenshot_region = "${screenshot} --capture region";

      # Color, themes, scaling
      colorText = "#FAFAFA";
      colorPrimary = "#CA9EE6EE";
      colorSecondary = "#99D1DBEE";
      colorInactive = "#303446AA";
      drop_shadow = "#1A1A1AEE";
      cursor_size = "24";
      qt_platform_theme = "gtk2";
      gdk_scale = "1.5";

      cycleSwayDisplayModes = pkgs.writeShellScriptBin "cycleSwayDisplayModes" ''
        # TODO: remove petalburg hardcodes
        current_mode=$(${config.wayland.windowManager.sway.package}/bin/swaymsg -t get_outputs -p | grep "Current mode" | grep -Eo '[0-9]+x[0-9]+ @ [0-9.]+ Hz' | tr -d " " | grep 2880)

        if [ $current_mode = "2880x1800@90.001Hz" ]; then
                ${config.wayland.windowManager.sway.package}/bin/swaymsg output "eDP-1" mode "2880x1800@60.001Hz";
                ${pkgs.libnotify}/bin/notify-send "Display set to 2880x1800@60.001Hz."
        elif [ $current_mode = "2880x1800@60.001Hz" ]; then
                ${config.wayland.windowManager.sway.package}/bin/swaymsg output "eDP-1" mode "2880x1800@90.001Hz";
                ${pkgs.libnotify}/bin/notify-send "Display set to 2880x1800@90.001Hz."
        fi
      '';
    in {
      bars = [];
      modifier = "${modifier}";
      colors.background = "${colorPrimary}";
      colors.focused = {
        background = "${colorPrimary}";
        border = "${colorPrimary}";
        childBorder = "${colorPrimary}";
        indicator = "${colorPrimary}";
        text = "${colorText}";
      };
      colors.focusedInactive = {
        background = "${colorSecondary}";
        border = "${colorSecondary}";
        childBorder = "${colorSecondary}";
        indicator = "${colorSecondary}";
        text = "${colorText}";
      };
      colors.unfocused = {
        background = "${colorSecondary}";
        border = "${colorSecondary}";
        childBorder = "${colorSecondary}";
        indicator = "${colorSecondary}";
        text = "${colorText}";
      };
      defaultWorkspace = "workspace number 1";
      focus = {
        followMouse = "always";
        newWindow = "smart";
        # mouseWarping = "container";
      };
      fonts = {
        names = ["NotoSansNerdFont"];
        style = "Bold";
        size = 12.0;
      };
      gaps.inner = 5;
      gaps.outer = 10;
      input = {
        "type:touchpad" = {
          click_method = "clickfinger";
          dwt = "enabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
          tap = "enabled";
          tap_button_map = "lrm";
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
        "${modifier}+B" = "exec ${browser}";
        "${modifier}+E" = "exec ${editor}";
        "${modifier}+F" = "exec ${fileManager}";
        "${modifier}+R" = "exec ${launcher}";
        "${modifier}+T" = "exec ${terminal}";

        # Manage session.
        "${modifier}+C" = "kill";
        "${modifier}+L" = "exec ${lock}";
        "${modifier}+M" = "exec ${logout}";

        # Basic window management.
        "${modifier}+Shift+W" = "fullscreen toggle";
        "${modifier}+Shift+V" = "floating toggle";

        # Move focus with modifier + arrow keys
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        # Move window with modifier SHIFT + arrow keys
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

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
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Move workspace to another output.
        "${modifier}+Control+Shift+Left" = "move workspace to output left";
        "${modifier}+Control+Shift+Down" = "move workspace to output down";
        "${modifier}+Control+Shift+Up" = "move workspace to output up";
        "${modifier}+Control+Shift+Right" = "move workspace to output right";

        # Scratchpad show and move
        "${modifier}+S" = "scratchpad show";
        "${modifier}+Shift+S" = "move scratchpad";

        # TODO: scroll with mouse up/down through workspaces

        # Display, volume, microphone, and media keys.
        "XF86MonBrightnessUp" = "exec ${brightness_up}";
        "XF86MonBrightnessDown" = "exec ${brightness_down}";
        "XF86AudioRaiseVolume" = "exec ${volume_up}";
        "XF86AudioLowerVolume" = "exec ${volume_down}";
        "XF86AudioMute" = "exec ${volume_mute}";
        "XF86AudioMicMute" = "exec ${mic_mute}";
        "XF86AudioPlay" = "exec ${media_play}";
        "XF86AudioPrev" = "exec ${media_prev}";
        "XF86AudioNext" = "exec ${media_next}";

        # For petalburg
        "XF86Launch4" = "exec pp-adjuster";

        "XF86Launch3" = "exec ${cycleSwayDisplayModes}/bin/cycleSwayDisplayModes";

        # TODO: night color shift
        # "XF86Launch1" =
        "XF86Launch2" = "exec ${media_play}";

        # Screenshots
        "PRINT" = "exec ${screenshot_screen}";
        "${modifier}+PRINT" = "exec ${screenshot_region}";

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
          Comma = "move container to workspace prev; workspace prev";
          Period = "move container to workspace next; workspace next";
          "1" = "move container to workspace number 1";
          "2" = "move container to workspace number 2";
          "3" = "move container to workspace number 3";
          "4" = "move container to workspace number 4";
          "5" = "move container to workspace number 5";
          "6" = "move container to workspace number 6";
          "7" = "move container to workspace number 7";
          "8" = "move container to workspace number 8";
          "9" = "move container to workspace number 9";
          "0" = "move container to workspace number 10";
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
      startup = [
        {command = "${bar}";}
        {command = "${wallpaperd}";}
        {command = "${fileManager} --daemon";}
        {command = "${idled}";}
        {command = "${notifyd}";}
        {command = "${pkgs.autotiling}/bin/autotiling";}
        {command = "${pkgs.gammastep}/bin/gammastep -l 31.1:-94.1";} # TODO: automatic locations
        {command = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";}
        {command = "${pkgs.networkmanagerapplet}/bin/nm-applet";}
        {command = "${pkgs.swayosd}/bin/swayosd-server";}
        {command = "${pkgs.playerctl}/bin/playerctld";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";}
      ];
      output = {
        "BOE 0x095F Unknown" = {
          scale = "1.5";
        };
        "LG Display 0x0569 Unknown" = {
          scale = "1.25";
        };
        "Samsung Display Corp. 0x4152 Unknown" = {
          scale = "2.0";
        };
        "LG Electronics LG ULTRAWIDE 311NTAB5M720" = {
          scale = "1.25";
        };
        "Guangxi Century Innovation Display Electronics Co., Ltd 27C1U-D 0000000000001" = {
          scale = "1.5";
          pos = "-2560 0";
        };
        "HP Inc. HP 24mh 3CM037248S   " = {
          scale = "1.0";
          pos = "-1920 0";
        };
      };
      window = {
        titlebar = false;
        commands = [
          {
            command = "floating enable; move position center";
            criteria = {
              app_id = "blueberry.py";
            };
          }
          {
            command = "floating enable; move position center";
            criteria = {
              app_id = "pavucontrol";
            };
          }
          {
            command = "floating enable; move position center";
            criteria = {
              app_id = "com.github.wwmm.easyeffects";
            };
          }
          {
            command = "floating enable; move position center";
            criteria = {
              window_role = "pop-up";
            };
          }
          {
            command = "floating enable; move position center";
            criteria = {
              window_role = "dialog";
            };
          }
          {
            command = "floating enable; move position center";
            criteria = {
              window_role = "bubble";
            };
          }
          {
            command = "floating enable; move position center";
            criteria = {
              window_type = "dialog";
            };
          }
          {
            command = "floating enable, resize set 70% 20%, sticky enable";
            criteria = {
              title = "^Picture-in-Picture$";
              app_id = "firefox";
            };
          }
        ];
      };
    };

    wayland.windowManager.sway.extraConfig = ''
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

      blur enable
      blur_passes 1
      corner_radius 10
      shadows enable

      layer_effects launcher blur enable
      layer_effects logout_dialog blur enable
    '';

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-wlr];
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };
  };
}
