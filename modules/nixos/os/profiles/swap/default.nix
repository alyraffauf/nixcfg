{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.swap = {
    enable = lib.mkEnableOption "swap file";

    size = lib.mkOption {
      default = 8192;
      description = "Swap size in megabytes.";
      type = lib.types.int;
    };
  };

  config = lib.mkIf config.myNixOS.profiles.swap.enable {
    swapDevices = [
      {
        device = "/.swap";
        priority = 0;
        randomEncryption.enable = true;
        size = config.myNixOS.profiles.swap.size;
      }
    ];
  };
}
