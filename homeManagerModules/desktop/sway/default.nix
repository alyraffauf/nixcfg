{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.sway.enable = lib.mkEnableOption "Sway with extra apps.";
  };

  config = lib.mkIf config.alyraffauf.desktop.sway.enable {
    alyraffauf = {
      apps = {
        waybar.enable = lib.mkDefault true;
        mako.enable = lib.mkDefault true;
        fuzzel.enable = lib.mkDefault true;
        wlogout.enable = lib.mkDefault true;
        alacritty.enable = lib.mkDefault true;
        firefox.enable = lib.mkDefault true;
        kanshi.enable = lib.mkDefault true;
      };
    };
    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      celluloid
      evince
      gnome.eog
      gnome.file-roller
      kdePackages.polkit-kde-agent-1
      networkmanagerapplet
      playerctl
      swayosd
      trayscale
      xfce.exo
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfce4-settings
      xfce.xfce4-taskmanager
      xfce.xfconf
      swayidle
    ];

    programs.swaylock.enable = lib.mkDefault true;

    services.cliphist.enable = lib.mkDefault true;

    programs.waybar.settings = {
      mainBar = {
        modules-left = ["sway/workspaces" "sway/mode"];
      };
    };

    wayland.windowManager.sway.enable = true;
    wayland.windowManager.sway.package = pkgs.swayfx;
    wayland.windowManager.sway.config = let
      modifier = "Mod4";

      # Default apps
      browser = pkgs.firefox + "/bin/firefox";
      fileManager = pkgs.xfce.thunar + "/bin/thunar";
      editor = pkgs.vscodium + "/bin/codium";
      terminal = pkgs.alacritty + "/bin/alacritty";

      # Sway desktop utilities
      bar = pkgs.waybar + "/bin/waybar";
      launcher = pkgs.fuzzel + "/bin/fuzzel";
      notifyd = pkgs.mako + "/bin/mako";
      wallpaperd = pkgs.swaybg + "/bin/swaybg -i ~/.local/share/backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg";
      idle = pkgs.swayidle + "/bin/swayidle";
      logout = pkgs.wlogout + "/bin/wlogout";
      lock = pkgs.swaylock + "/bin/swaylock -f -c 000000";

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

      screenshot = "${pkgs.grim}/bin/grim";
      screenshot_folder = "~/pics/screenshots";
      screenshot_screen = "${screenshot} ${screenshot_folder}/$(date +'%s_grim.png')";
      # screenshot_region = "${screenshot} -m region -o ${screenshot_folder}";

      # Color, themes, scaling
      colorPrimary = "ca9ee6ee";
      colorSecondary = "99d1dbee";
      border_inactive = "303446aa";
      drop_shadow = "1a1a1aee";
      cursor_size = "24";
      qt_platform_theme = "gtk2";
      gdk_scale = "1.5";
    in {
      bars = [{command = "${bar}";}];
      terminal = "${terminal}";
      menu = "${launcher}";
      modifier = "${modifier}";
      colors.background = "${colorPrimary}";
      colors.focused = {
        background = "${colorPrimary}";
        border = "${colorPrimary}";
        childBorder = "${colorPrimary}";
        indicator = "${colorPrimary}";
        text = "#ffffff";
      };
      colors.focusedInactive = {
        background = "${colorSecondary}";
        border = "${colorSecondary}";
        childBorder = "${colorSecondary}";
        indicator = "${colorSecondary}";
        text = "#ffffff";
      };
      colors.unfocused = {
        background = "${colorSecondary}";
        border = "${colorSecondary}";
        childBorder = "${colorSecondary}";
        indicator = "${colorSecondary}";
        text = "#ffffff";
      };
      gaps.inner = 5;
      gaps.outer = 10;
      window.titlebar = false;
      fonts = {
        names = ["Noto SansM Nerd Font"];
        style = "Bold";
        size = 12.0;
      };
      startup = [
        {command = "${wallpaperd}";}
        {command = "${pkgs.kanshi}";}
        {command = "${notifyd}";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store";}
        {command = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";}
        {command = "${fileManager} --daemon";}
        {command = "${pkgs.swayosd}/bin/swayosd-server";}
        {command = "${pkgs.networkmanagerapplet}/bin/nm-applet";}
        {command = "${pkgs.trayscale}/bin/trayscale --hide-window";}
        {command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock' before-sleep '${pkgs.swaylock}/bin/swaylock'";}
      ];
      output = {
        "BOE 0x095F Unknown" = {
          scale = "1.5";
        };
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
        # TODO: night color shift
        # "XF86Launch1" =
        "XF86Launch2" = "exec ${media_play}";

        # Screenshots
        "PRINT" = "exec ${screenshot_screen}";
        # "${modifier}+PRINT" = "${screenshot_region}";

        # Show/hide waybar
        "${modifier}+F11" = "exec pkill -SIGUSR1 waybar";

        "Mod1+R" = "mode resize";
        "Mod1+M" = "mode move";
      };
      modes = {
        resize = {
          Escape = "mode default";
          Left = "resize shrink width 10 px";
          Down = "resize grow height 10 px";
          Up = "resize shrink height 10 px";
          Right = "resize grow width 10 px";
        };
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
      };
    };

    wayland.windowManager.sway.extraConfig = ''
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next

      blur enable
      blur_passes 1
      corner_radius 10
      shadows enable

      layer_effects waybar blur enable
      layer_effects launcher blur enable
      layer_effects logout_dialog blur enable
    '';

    xdg.configFile."xfce4/helpers.rc".text = ''
      TerminalEmulator=alacritty
      FileManager=thunar
      WebBrowser=firefox
    '';

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-wlr];
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };
  };
}
