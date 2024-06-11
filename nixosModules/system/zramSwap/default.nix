{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.system.zramSwap.enable {
    zramSwap = {
      enable = true;
      memoryPercent = config.alyraffauf.system.zramSwap.size;
    };
  };
}
