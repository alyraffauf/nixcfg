{
  config,
  lib,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    allowReboot = lib.mkDefault true;
    dates = "02:00";
    flags = ["--accept-flake-config"];
    flake = config.environment.variables.FLAKE or "github:alyraffauf/nixcfg";
    operation = lib.mkDefault "boot";
    persistent = true;
    randomizedDelaySec = "60min";

    rebootWindow = {
      lower = "02:00";
      upper = "06:00";
    };
  };
}
