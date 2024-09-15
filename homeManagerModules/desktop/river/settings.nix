{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  focused = config.lib.stylix.colors.base0D;
  helpers = import ../wayland/helpers.nix {inherit config lib pkgs;};
  modifier = "Super";
  unfocused = config.lib.stylix.colors.base03;
  urgent = config.lib.stylix.colors.base08;
in {
  enable = true;

  extraConfig = ''
    touchpad=`riverctl list-inputs|grep -i touchpad`
    for t in ''${touchpad[@]}; do
      riverctl input $t natural-scroll enabled
      riverctl input $t click-method clickfinger
      riverctl input $t tap enabled
      riverctl input $t disable-while-typing enabled
    done

    for i in $(seq 1 8)
    do
      tags=$((1 << ($i - 1)))

      # ${modifier}+[1-9] to focus tag [0-8]
      riverctl map normal ${modifier} $i set-focused-tags $tags

      # ${modifier}+Shift+[1-9] to tag focused view with tag [0-8]
      riverctl map normal ${modifier}+Shift $i set-view-tags $tags

      # ${modifier}+Control+[1-9] to toggle focus of tag [0-8]
      riverctl map normal ${modifier}+Control $i toggle-focused-tags $tags

      # ${modifier}+Shift+Control+[1-9] to toggle tag [0-8] of focused view
      riverctl map normal ${modifier}+Shift+Control $i toggle-view-tags $tags
    done
  '';

  systemd.enable = true;

  settings = {
    border-color-focused = "0x${focused}";
    border-color-unfocused = "0x${unfocused}";
    border-color-urgent = "0x${urgent}";
    border-width = 4;

    default-layout = "rivertile";

    declare-mode = [
      "locked"
      "normal"
    ];

    focus-follows-cursor = "normal";

    map = {
      normal = {
        "${modifier} B" = "spawn ${lib.getExe cfg.defaultApps.webBrowser}";
        "${modifier} C" = "close";
        "${modifier} E" = "spawn ${lib.getExe cfg.defaultApps.editor}";
        "${modifier} F" = "spawn ${lib.getExe cfg.defaultApps.fileManager}";
        "${modifier} M" = ''spawn "${lib.getExe config.programs.rofi.package} -show power-menu -modi 'power-menu:${lib.getExe pkgs.rofi-power-menu} --choices=logout/lockscreen/suspend/shutdown/reboot'"'';
        "${modifier} R" = "spawn '${lib.getExe config.programs.rofi.package} -show combi'";
        "${modifier} T" = "spawn ${lib.getExe cfg.defaultApps.terminal}";
        "${modifier}+Control L" = "spawn ${lib.getExe pkgs.swaylock}";
        "${modifier}+Shift V" = "toggle-float";
      };
    };

    map-pointer.normal = {
      "${modifier} BTN_LEFT" = "move-view";
      "${modifier} BTN_RIGHT" = "resize-view";
    };

    rule-add = {
      "" = "ssd";
    };

    spawn = [
      "rivertile"
    ];
  };
}
