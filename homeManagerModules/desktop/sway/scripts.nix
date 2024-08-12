{
  config,
  lib,
  pkgs,
  ...
}: let
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
in {
  clamshell = pkgs.writeShellScript "sway-clamshell" ''
    docked() {
     	[ "$(${swaymsg} -t get_outputs | ${lib.getExe pkgs.jq} '. | length')" -ne 1 ] && return 0
     	return 1
    }

    if [ "$1" == "on" ]; then
      docked && swaymsg output eDP-1 disable
    elif [ "$1" == "off" ]; then
      swaymsg output eDP-1 enable
    fi
  '';
}
