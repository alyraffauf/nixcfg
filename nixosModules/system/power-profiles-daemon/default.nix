{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.system.power-profiles-daemon.enable =
      lib.mkEnableOption "Enables power-profiles-daemon.";
  };

  config = lib.mkIf config.alyraffauf.system.power-profiles-daemon.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
