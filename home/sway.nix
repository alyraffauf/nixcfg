{ config, pkgs, ... }:

{
  programs.waybar.enable = true; # bar
  programs.waybar.systemd.enable = true;
  programs.swaylock.enable = true;
  services.swayidle.enable = true;

  services.network-manager-applet.enable = true;

  home.packages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        wf-recorder
        mako # notification daemon
        grim
        kanshi
        slurp
        dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];


  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "bottom";
      height = 30;
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "tray" ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      bars = [];
      gaps = {
        inner = 10;
      };
      # output = {
      #   eDP-1 = {
      #     scale = "1.0";
      #   };
      # };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          drag = "enabled";
          scroll_method = "two_finger";
          dwt = "enabled";
          click_method = "clickfinger";
        };
      };
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
      keybindings = {
        # audio control
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --increase 10";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --decrease 10";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
        "Mod4+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      };
    };
  };
}