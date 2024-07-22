{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
in {
  idleD = pkgs.writeShellScript "sway-idled" ''
    ${lib.getExe pkgs.swayidle} -w \
      before-sleep '${lib.getExe pkgs.playerctl} pause' \
      before-sleep '${lib.getExe pkgs.swaylock}' \
      timeout 240 '${lib.getExe pkgs.brightnessctl} -s set 10' \
        resume '${lib.getExe pkgs.brightnessctl} -r' \
      timeout 300 '${lib.getExe pkgs.swaylock}' \
      timeout 330 '${swaymsg} "output * dpms off"' \
        resume '${swaymsg} "output * dpms on"' \
      ${
      if cfg.desktop.sway.autoSuspend
      then ''timeout 900 '${lib.getExe' pkgs.systemd "systemctl"} suspend' \''
      else ''\''
    }
  '';
}
