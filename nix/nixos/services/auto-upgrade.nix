_: {
  flake.nixosModules.default = {config, ...}: {
    system.autoUpgrade = {
      enable = true;
      allowReboot = false;
      dates = "02:00";
      fixedRandomDelay = true;
      flake = "github:alyraffauf/hoenn#${config.networking.hostName}";
      flags = ["--accept-flake-config"];
      operation = "boot";
      persistent = true;
      randomizedDelaySec = "45min";
      upgrade = false;
    };

    systemd.services.nixos-upgrade = {
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "15min";
      };

      unitConfig = {
        StartLimitBurst = 2;
        StartLimitIntervalSec = "1h";
      };
    };
  };
}
