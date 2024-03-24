{ config, pkgs, ... }:

{
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25;
}
