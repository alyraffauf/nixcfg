{
  pkgs,
  lib,
  config,
  ...
}: let
  pp-adjuster = pkgs.writeShellScriptBin "pp-adjuster" ''
    current_profile=$(${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} get | tr -d '[:space:]')

    if [ "$current_profile" == "power-saver" ]; then
        ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set balanced
    elif [ "$current_profile" == "balanced" ]; then
        ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set performance
    elif [ "$current_profile" == "performance" ]; then
        ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set power-saver
    fi

    new_profile=$(${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} get | tr -d '[:space:]')
    ${lib.getExe pkgs.libnotify} "Power profile set to $new_profile."
  '';
in {
  config = lib.mkIf config.ar.home.scripts.pp-adjuster.enable {
    home.packages = [pp-adjuster];
  };
}
