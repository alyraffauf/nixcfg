{config, ...}: {
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "02:00";
    flags = ["--accept-flake-config"];
    flake = config.environment.variables.FLAKE;
    operation = "switch";
    persistent = true;
    randomizedDelaySec = "60min";

    rebootWindow = {
      lower = "02:00";
      upper = "06:00";
    };
  };
}
