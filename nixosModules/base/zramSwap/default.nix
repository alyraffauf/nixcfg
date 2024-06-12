{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.base.zramSwap.enable {
    zramSwap = {
      enable = true;
      memoryPercent = config.alyraffauf.base.zramSwap.size;
    };
  };
}
