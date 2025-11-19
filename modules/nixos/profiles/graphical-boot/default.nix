{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.graphical-boot.enable = lib.mkEnableOption "non-text boot experience";

  config = lib.mkIf config.myNixOS.profiles.graphical-boot.enable {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      loader.timeout = 0;
      plymouth.enable = true;
    };
  };
}
