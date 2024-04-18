{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.system.zramSwap.enable = lib.mkEnableOption "Enables zram swap.";
    alyraffauf.system.zramSwap.size = lib.mkOption {
      description = "Percent size of the zram swap.";
      default = 50;
      type = lib.types.int;
    };
  };

  config = lib.mkIf config.alyraffauf.system.zramSwap.enable {
    zramSwap = {
      enable = true;
      memoryPercent = config.alyraffauf.system.zramSwap.size;
    };
  };
}
