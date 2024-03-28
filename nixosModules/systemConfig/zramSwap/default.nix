{ pkgs, lib, config, ... }: {

  options = {
    systemConfig.zramSwap.enable = lib.mkEnableOption "Enables zram swap.";
  };

  config = lib.mkIf config.systemConfig.zramSwap.enable {
    zramSwap = {
        enable = true;
        memoryPercent = 25;
    };
  };
}
