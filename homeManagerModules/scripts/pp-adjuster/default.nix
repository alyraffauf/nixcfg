{
  pkgs,
  lib,
  config,
  ...
}: let
  pp-adjuster = pkgs.writeShellScriptBin "pp-adjuster" ''
    # Only works on petalburg.
    current_profile=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get | tr -d '[:space:]')

    if [ "$current_profile" == "power-saver" ]; then
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
    elif [ "$current_profile" == "balanced" ]; then
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
    elif [ "$current_profile" == "performance" ]; then
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
    fi

    new_profile=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get | tr -d '[:space:]')
    ${pkgs.libnotify}/bin/notify-send "Power profile set to $new_profile."
  '';
in {
  options = {alyraffauf.scripts.pp-adjuster.enable = lib.mkEnableOption "Enable pp-adjuster script.";};

  config = lib.mkIf config.alyraffauf.scripts.pp-adjuster.enable {
    home.packages = [pp-adjuster];
  };
}
