{
  config,
  lib,
  ...
}: {
  options.myHardware.profiles.ssd.enable = lib.mkEnableOption "SSD support";

  config = lib.mkIf config.myHardware.profiles.ssd.enable {
    services.fstrim.enable = true;
  };
}
