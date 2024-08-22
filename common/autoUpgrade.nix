{
  config,
  lib,
  ...
}: {
  environment.variables.FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "02:00";
    flags = ["--accept-flake-config"];
    flake = config.environment.variables.FLAKE;
    operation = "switch";
    persistent = true;
    randomizedDelaySec = "30min";

    rebootWindow = {
      lower = "02:00";
      upper = "06:00";
    };
  };
}
