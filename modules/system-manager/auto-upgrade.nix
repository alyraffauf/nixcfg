_: {
  flake.systemModules.default = {
    system.autoUpgrade = {
      enable = true;
      dates = "02:00";
      fixedRandomDelay = true;
      flake = "github:alyraffauf/hoenn#systemConfigs.sootopolis";
      persistent = true;
      randomizedDelaySec = "45min";
    };

    systemd.services.system-manager-upgrade = {
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
