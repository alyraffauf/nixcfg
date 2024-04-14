{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktopEnv.sway.enable = lib.mkEnableOption "Sway with extra apps.";
  };

  config = lib.mkIf config.desktopEnv.sway.enable {
    # Basic apps needed to run a hyprland desktop.
    guiApps.waybar.enable = lib.mkDefault true;
    guiApps.mako.enable = lib.mkDefault true;
    guiApps.fuzzel.enable = lib.mkDefault true;
    guiApps.wlogout.enable = lib.mkDefault true;
    guiApps.alacritty.enable = lib.mkDefault true;
    guiApps.firefox.enable = lib.mkDefault true;
    guiApps.kanshi.enable = lib.mkDefault true;

    # Packages that should be installed to the user profile.
    home.packages = with pkgs; [
      # brightnessctl
      # hyprnome
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

    wayland.windowManager.sway.enable = true;
    wayland.windowManager.sway.config = let
      modifier = "Mod4";

      # Default apps
      browser = pkgs.firefox + "/bin/firefox";
      fileManager = pkgs.xfce.thunar + "/bin/thunar";
      editor = pkgs.vscodium + "/bin/codium";
      terminal = pkgs.alacritty + "/bin/alacritty";

      # River desktop utilities
      bar = pkgs.waybar + "/bin/waybar";
      launcher = pkgs.fuzzel + "/bin/fuzzel";
      notifyd = pkgs.mako + "/bin/mako";
      wallpaperd = pkgs.swaybg + "/bin/swaybg";
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
      media_previous = "${media} previous";

      # screenshot = "${pkgs.hyprshot}/bin/hyprshot";
      # screenshot_folder = "~/pics/screenshots";
      # screenshot_screen = "${screenshot} -m output -o ${screenshot_folder}";
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
      # bars.waybar.command = "${pkgs.waybar}/bin/waybar";
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
        # { command = "${pkgs.kanshi}"; }
        {command = "nm-applet";}
        {command = "swayosd-server";}
        {command = "thunar --daemon";}
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
      keybindings = lib.mkOptionDefault {
        "${modifier}+r" = "exec ${launcher}";
        "${modifier}+t" = "exec ${terminal}";
        "${modifier}+b" = "exec ${browser}";
        "${modifier}+e" = "exec ${editor}";
        "${modifier}+f" = "exec ${fileManager}";

        "${modifier}+c" = "kill";

        "${modifier}+l" = "exec ${lock}";
        "${modifier}+m" = "exec ${logout}";

        "${modifier}+w" = "fullscreen toggle";
        "${modifier}+v" = "floating toggle";

        "${modifier}+s" = "scratchpad show";
        "${modifier}+Shift+s" = "move scratchpad";

        "${modifier}+period" = "workspace next";
        "${modifier}+comma" = "workspace prev";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";

        "${modifier}+Shift+period" = "move container to workspace next; workspace next";
        "${modifier}+Shift+comma" = "move container to workspace prev; workspace prev";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        # audio control
        "XF86AudioRaiseVolume" = "exec ${volume_up}";
        "XF86AudioLowerVolume" = "exec ${volume_down}";
        "XF86AudioMute" = "exec ${volume_mute}";

        # mic control
        "XF86AudioMicMute" = "exec ${mic_mute}";

        # brightness
        "XF86MonBrightnessUp" = "exec ${brightness_up}";
        "XF86MonBrightnessDown" = "exec ${brightness_down}";
      };
    };

    wayland.windowManager.sway.extraConfig = ''
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next
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
