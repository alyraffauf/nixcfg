{ pkgs, lib, config, ... }: {

  options = {
    systemConfig.power-profiles-daemon.enable = lib.mkEnableOption
      "Enables power-profiles-daemon.";
  };

  config = lib.mkIf config.systemConfig.power-profiles-daemon.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
