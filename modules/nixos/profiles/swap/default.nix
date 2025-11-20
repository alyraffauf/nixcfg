{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.swap.enable = lib.mkEnableOption "swap and oomd configurations";

  config = lib.mkIf config.myNixOS.profiles.swap.enable {
    swapDevices = [
      {
        device = "/.swap";
        priority = 0;
        randomEncryption.enable = true;
        size = 8192;
      }
    ];

    systemd.oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
    };

    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };
  };
}
