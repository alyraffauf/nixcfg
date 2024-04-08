{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    systemConfig.plymouth.enable =
      lib.mkEnableOption
      "Enables plymouth boot screen with reduced text verbosity.";
  };

  config = lib.mkIf config.systemConfig.plymouth.enable {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth.enable = true;
    };
  };
}
