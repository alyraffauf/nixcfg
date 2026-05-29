{
  config,
  lib,
  ...
}: {
  options.myHardware.profiles.base.enable = lib.mkEnableOption "Base common hardware configuration";

  config = lib.mkIf config.myHardware.profiles.base.enable {
    hardware.enableAllFirmware = true;
    services.fstrim.enable = true;
  };
}
