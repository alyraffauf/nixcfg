_: {
  flake.nixosModules.default = {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "rd.systemd.show_status=auto"
        "udev.log_level=3"
      ];

      loader.timeout = 1;
      plymouth.enable = true;
    };
  };
}
