{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./amd-7000
    ./intel-11th
  ];

  options.myHardware.framework.laptop13.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.myHardware.framework.laptop13.amd-7000.enable || config.myHardware.framework.laptop13.intel-11th.enable;
    description = "Framework Laptop 13 specific hardware configuration";
  };

  config = lib.mkIf config.myHardware.framework.laptop13.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        framework-laptop-kmod
      ];

      kernelModules = [
        # https://github.com/DHowett/framework-laptop-kmod?tab=readme-ov-file#usage
        "cros_ec_lpcs"
        "cros_ec"
      ];
    };

    environment.systemPackages = [pkgs.framework-tool] ++ lib.optional (pkgs ? "fw-ectool") pkgs.fw-ectool;

    hardware.sensor.iio.enable = true;

    services = {
      fprintd.enable = true;
      fwupd.enable = true;

      udev.extraRules = ''
        ## Framework ethernet expansion card support
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
      '';
    };
  };
}
