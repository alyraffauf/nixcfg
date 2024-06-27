{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.base.zramSwap.enable {
    zramSwap = {
      enable = true;
      memoryPercent = config.ar.base.zramSwap.size;
    };
  };
}
