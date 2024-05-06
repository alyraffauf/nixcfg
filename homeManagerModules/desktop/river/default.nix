{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  imports = [./randomWallpaper.nix];
  options = {
    alyraffauf.desktop.river.enable =
      lib.mkEnableOption "Enable riverwm with extra apps.";
    alyraffauf.desktop.river.autoSuspend = lib.mkOption {
      description = "Whether to autosuspend on idle.";
      default = true;
      type = lib.types.bool;
    };
    alyraffauf.desktop.river.gtkBorderFix = lib.mkOption {
      description = "Fix GTK borders.";
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.river.enable {
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
      desktop = {
        river.randomWallpaper = lib.mkDefault true;
        theme.enable = lib.mkDefault true;
        defaultApps.enable = lib.mkDefault true;
      };
    };

    programs.swaylock.enable = lib.mkDefault true;

    services.cliphist.enable = lib.mkDefault true;
    services.swayosd.enable = lib.mkDefault true;

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-wlr];
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };

    # gtk.gtk3.extraCss =
    #   if config.alyraffauf.desktop.river.gtkBorderFix
    #   then ''
    #     /* No (default) title bar on wayland */
    #     headerbar.default-decoration {
    #       /* You may need to tweak these values depending on your GTK theme */
    #       margin-bottom: 50px;
    #       margin-top: -100px;

    #       background: transparent;
    #       padding: 0;
    #       border: 0;
    #       min-height: 0;
    #       font-size: 0;
    #       box-shadow: none;
    #     }

    #     /* rm -rf window shadows */
    #     window.csd,             /* gtk4? */
    #     window.csd decoration { /* gtk3 */
    #       box-shadow: none;
    #     }
    #   ''
    #   else "/* */";

    # gtk.gtk4.extraCss =
    #   if config.alyraffauf.desktop.river.gtkBorderFix
    #   then ''
    #     /* No (default) title bar on wayland */
    #     headerbar.default-decoration {
    #       /* You may need to tweak these values depending on your GTK theme */
    #       margin-bottom: 50px;
    #       margin-top: -100px;

    #       background: transparent;
    #       padding: 0;
    #       border: 0;
    #       min-height: 0;
    #       font-size: 0;
    #       box-shadow: none;
    #     }

    #     /* rm -rf window shadows */
    #     window.csd,             /* gtk4? */
    #     window.csd decoration { /* gtk3 */
    #       box-shadow: none;
    #     }
    #   ''
    #   else "/* */";

    programs.waybar.settings = {
      mainBar = {
        modules-left = ["river/tags" "river/mode"];
      };
    };

    wayland.windowManager.river.enable = true;
    wayland.windowManager.river.extraConfig = let
      modifier = "Super";

      # Default apps
      browser = config.alyraffauf.desktop.defaultApps.webBrowser.exe;
      fileManager = lib.getExe pkgs.xfce.thunar;
      editor = config.alyraffauf.desktop.defaultApps.editor.exe;
      terminal = config.alyraffauf.desktop.defaultApps.terminal.exe;

      # River desktop utilities
      bar = pkgs.waybar + "/bin/waybar";
      launcher = pkgs.fuzzel + "/bin/fuzzel";
      notifyd = pkgs.mako + "/bin/mako";
      wallpaperd = pkgs.swaybg + "/bin/swaybg -i ${config.alyraffauf.desktop.theme.wallpaper}";
      logout = pkgs.wlogout + "/bin/wlogout";
      lock = pkgs.swaylock + "/bin/swaylock";
      idled =
        if config.alyraffauf.desktop.river.autoSuspend
        then ''
          ${pkgs.swayidle}/bin/swayidle -w \
                  timeout 240 '${pkgs.brightnessctl}/bin/brightnessctl -s set 10' \
                    resume '${pkgs.brightnessctl}/bin/brightnessctl -r' \
                  timeout 300 '${lock}' \
                  before-sleep '${lock}' ''
        else ''
          ${pkgs.swayidle}/bin/swayidle -w \
                  timeout 240 '${pkgs.brightnessctl}/bin/brightnessctl -s set 10' \
                    resume '${pkgs.brightnessctl}/bin/brightnessctl -r' \
                  timeout 300 '${lock}' \
                  timeout 900 '${pkgs.systemd}/bin/systemctl suspend' \
                  before-sleep '${lock}' '';
      riverctl = "${config.wayland.windowManager.river.package}/bin/riverctl";

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

      screenshot = "${pkgs.shotman}/bin/shotman";
      # screenshot_folder = "~/pics/screenshots";
      # screenshot_screen = "${screenshot} ${screenshot_folder}/$(date +'%s_grim.png')";
      # screenshot_region = "${screenshot} -m region -o ${screenshot_folder}";
      screenshot_screen = "${screenshot} --capture output";
      screenshot_region = "${screenshot} --capture region";

      qt_platform_theme = "gtk2";
      gdk_scale = "1.5";
    in ''
      pkill -f kanshi
      pkill -f mako
      pkill -f nm-applet
      pkill -f swayosd-server
      pkill -f waybar
      pkill -f swayidle
      touchpad=`${riverctl} list-inputs|grep -i touchpad`
      for t in ''${touchpad[@]}; do
        ${riverctl} input $t natural-scroll enabled
        ${riverctl} input $t click-method clickfinger
        ${riverctl} input $t tap enabled
        ${riverctl} input $t disable-while-typing enabled
      done

      ${riverctl} focus-follows-cursor always

      ${riverctl} map normal ${modifier} T spawn ${terminal}
      ${riverctl} map normal ${modifier} R spawn ${launcher}
      ${riverctl} map normal ${modifier} B spawn ${browser}
      ${riverctl} map normal ${modifier} E spawn ${editor}
      ${riverctl} map normal ${modifier} F spawn ${fileManager}

      ${riverctl} map normal ${modifier} M spawn ${logout}

      # ${modifier}+C to close the focused view
      ${riverctl} map normal ${modifier} C close

      # ${modifier}+Shift+E to exit river
      ${riverctl} map normal ${modifier}+Shift E exit

      # ${modifier}+J and ${modifier}+K to focus the next/previous view in the layout stack
      ${riverctl} map normal ${modifier} J focus-view next
      ${riverctl} map normal ${modifier} K focus-view previous

      # ${modifier}+Shift+J and ${modifier}+Shift+K to swap the focused view with the next/previous
      # view in the layout stack
      ${riverctl} map normal ${modifier}+Shift J swap next
      ${riverctl} map normal ${modifier}+Shift K swap previous

      # ${modifier}+Period and ${modifier}+Comma to focus the next/previous output
      ${riverctl} map normal ${modifier} Period focus-output next
      ${riverctl} map normal ${modifier} Comma focus-output previous

      # ${modifier}+Shift+{Period,Comma} to send the focused view to the next/previous output
      ${riverctl} map normal ${modifier}+Shift Period send-to-output next
      ${riverctl} map normal ${modifier}+Shift Comma send-to-output previous

      # ${modifier}+Return to bump the focused view to the top of the layout stack
      ${riverctl} map normal ${modifier} Return zoom

      # ${modifier}+H and ${modifier}+L to decrease/increase the main ratio of rivertile(1)
      ${riverctl} map normal ${modifier} H send-layout-cmd rivertile "main-ratio -0.05"
      ${riverctl} map normal ${modifier} L send-layout-cmd rivertile "main-ratio +0.05"

      # ${modifier}+Shift+H and ${modifier}+Shift+L to increment/decrement the main count of rivertile(1)
      ${riverctl} map normal ${modifier}+Shift H send-layout-cmd rivertile "main-count +1"
      ${riverctl} map normal ${modifier}+Shift L send-layout-cmd rivertile "main-count -1"

      # ${modifier}+Alt+{H,J,K,L} to move views
      ${riverctl} map normal ${modifier}+Alt H move left 100
      ${riverctl} map normal ${modifier}+Alt J move down 100
      ${riverctl} map normal ${modifier}+Alt K move up 100
      ${riverctl} map normal ${modifier}+Alt L move right 100

      # ${modifier}+Alt+Control+{H,J,K,L} to snap views to screen edges
      ${riverctl} map normal ${modifier}+Alt+Control H snap left
      ${riverctl} map normal ${modifier}+Alt+Control J snap down
      ${riverctl} map normal ${modifier}+Alt+Control K snap up
      ${riverctl} map normal ${modifier}+Alt+Control L snap right

      # ${modifier}+Alt+Shift+{H,J,K,L} to resize views
      ${riverctl} map normal ${modifier}+Alt+Shift H resize horizontal -100
      ${riverctl} map normal ${modifier}+Alt+Shift J resize vertical 100
      ${riverctl} map normal ${modifier}+Alt+Shift K resize vertical -100
      ${riverctl} map normal ${modifier}+Alt+Shift L resize horizontal 100

      # ${modifier} + Left Mouse Button to move views
      ${riverctl} map-pointer normal ${modifier} BTN_LEFT move-view

      # ${modifier} + Right Mouse Button to resize views
      ${riverctl} map-pointer normal ${modifier} BTN_RIGHT resize-view

      # ${modifier} + Middle Mouse Button to toggle float
      ${riverctl} map-pointer normal ${modifier} BTN_MIDDLE toggle-float

      for i in $(seq 1 8)
      do
          tags=$((1 << ($i - 1)))

          # ${modifier}+[1-9] to focus tag [0-8]
          ${riverctl} map normal ${modifier} $i set-focused-tags $tags

          # ${modifier}+Shift+[1-9] to tag focused view with tag [0-8]
          ${riverctl} map normal ${modifier}+Shift $i set-view-tags $tags

          # ${modifier}+Control+[1-9] to toggle focus of tag [0-8]
          ${riverctl} map normal ${modifier}+Control $i toggle-focused-tags $tags

          # ${modifier}+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          ${riverctl} map normal ${modifier}+Shift+Control $i toggle-view-tags $tags
      done

      # ${modifier}+0 to focus all tags
      # ${modifier}+Shift+0 to tag focused view with all tags
      all_tags=$(((1 << 32) - 1))
      ${riverctl} map normal ${modifier} 0 set-focused-tags $all_tags
      ${riverctl} map normal ${modifier}+Shift 0 set-view-tags $all_tags

      # ${modifier}+Space to toggle float
      ${riverctl} map normal ${modifier} V toggle-float

      # ${modifier}+F to toggle fullscreen
      ${riverctl} map normal ${modifier} W toggle-fullscreen

      # ${modifier}+{Up,Right,Down,Left} to change layout orientation
      ${riverctl} map normal ${modifier} Up    send-layout-cmd rivertile "main-location top"
      ${riverctl} map normal ${modifier} Right send-layout-cmd rivertile "main-location right"
      ${riverctl} map normal ${modifier} Down  send-layout-cmd rivertile "main-location bottom"
      ${riverctl} map normal ${modifier} Left  send-layout-cmd rivertile "main-location left"

      # Declare a passthrough mode. This mode has only a single mapping to return to
      # normal mode. This makes it useful for testing a nested wayland compositor
      ${riverctl} declare-mode passthrough

      # ${modifier}+F11 to enter passthrough mode
      ${riverctl} map normal ${modifier} F11 enter-mode passthrough

      # ${modifier}+F11 to return to normal mode
      ${riverctl} map passthrough ${modifier} F11 enter-mode normal

      # Various media key mapping examples for both normal and locked mode which do
      # not have a modifier
      for mode in normal locked
      do
          ${riverctl} map $mode None XF86Eject spawn 'eject -T'

          # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          ${riverctl} map $mode None XF86AudioRaiseVolume  spawn '${volume_up}'
          ${riverctl} map $mode None XF86AudioLowerVolume  spawn '${volume_down}'
          ${riverctl} map $mode None XF86AudioMute         spawn '${volume_mute}'

          ${riverctl} map $mode None XF86AudioMedia spawn '${media_play}'
          ${riverctl} map $mode None XF86AudioPlay  spawn '${media_play}'
          ${riverctl} map $mode None XF86AudioPrev  spawn '${media_previous}'
          ${riverctl} map $mode None XF86AudioNext  spawn '${media_next}'

          ${riverctl} map $mode None XF86MonBrightnessUp   spawn '${brightness_up}'
          ${riverctl} map $mode None XF86MonBrightnessDown spawn '${brightness_down}'
      done

      # Set background and border color
      ${riverctl} background-color 0x00000000
      ${riverctl} border-color-focused 0x${config.alyraffauf.desktop.theme.colors.primary}
      ${riverctl} border-color-unfocused 0x${config.alyraffauf.desktop.theme.colors.secondary}

      # Set keyboard repeat rate
      ${riverctl} set-repeat 50 300

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      ${riverctl} default-layout rivertile
      rivertile -view-padding 6 -outer-padding 6 &

      ${pkgs.kanshi}/bin/kanshi &
      ${notifyd} &
      ${pkgs.networkmanagerapplet}/bin/nm-applet &
      ${pkgs.swayosd}/bin/swayosd-server &
      ${fileManager} --daemon &
      ${bar} &
      ${idled} &
      ${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1 &
    '';
  };
}
