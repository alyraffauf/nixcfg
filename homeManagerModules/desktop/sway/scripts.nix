{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
in {
  idleD = let
    timeouts =
      ["timeout 120 '${lib.getExe pkgs.brightnessctl} -s set 10' resume '${lib.getExe pkgs.brightnessctl} -r'"]
      ++ (
        if cfg.desktop.sway.autoSuspend
        then ["timeout 600 'sleep 2 && ${lib.getExe' pkgs.systemd "systemctl"} suspend'"]
        else [
          "timeout 600 '${lib.getExe pkgs.swaylock}'"
          "timeout 630 '${swaymsg} \"output * dpms off\"' resume '${swaymsg} \"output * dpms on\"'"
        ]
      );

    beforeSleeps =
      lib.optionals cfg.desktop.sway.autoSuspend
      [
        "before-sleep '${lib.getExe pkgs.playerctl} pause'"
        "before-sleep '${lib.getExe pkgs.swaylock}'"
      ];
  in
    pkgs.writeShellScript "sway-idled"
    "${lib.getExe pkgs.swayidle} -w lock '${lib.getExe pkgs.swaylock}' ${lib.strings.concatStringsSep " " (timeouts ++ beforeSleeps)}";
}
