{ pkgs, lib, config, ... }: {

  options = {
    systemConfig.zramSwap.enable = lib.mkEnableOption "Enables zram swap.";
    systemConfig.zramSwap.size = lib.mkOption {
      description = "Percent size of the zram swap.";
      default = 50;
      type = lib.types.int;
    };
  };

  config = lib.mkIf config.systemConfig.zramSwap.enable {
    zramSwap = {
      enable = true;
      memoryPercent = config.systemConfig.zramSwap.size;
    };
  };
}
