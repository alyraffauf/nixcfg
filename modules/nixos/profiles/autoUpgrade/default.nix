{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.autoUpgrade = {
    enable = lib.mkEnableOption "auto-upgrade system";

    operation = lib.mkOption {
      type = lib.types.str;
      default = "switch";
      description = "Operation to perform on auto-upgrade. Can be 'boot', 'switch', or 'test'.";
    };

    dates = lib.mkOption {
      type = lib.types.str;
      default = "02:00";
      description = ''
        systemd OnCalendar expression for when the upgrade fires.
      '';
    };

    randomizedDelaySec = lib.mkOption {
      type = lib.types.str;
      default = "0";
      description = ''
        Random delay added on top of `dates`.
      '';
    };
  };

  config = lib.mkIf config.myNixOS.profiles.autoUpgrade.enable {
    system.autoUpgrade = {
      inherit (config.myNixOS.profiles.autoUpgrade) operation dates randomizedDelaySec;

      enable = true;
      allowReboot = true;
      flags = ["--accept-flake-config"];
      flake = config.myNixOS.FLAKE;
      persistent = true;

      rebootWindow = {
        lower = "02:00";
        upper = "06:00";
      };
    };

    # Allow nixos-upgrade to restart on failure (e.g. when laptop wakes up before network connection is set)
    systemd.services.nixos-upgrade = {
      preStart = "${pkgs.host}/bin/host google.com"; # Check network connectivity

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "120";
      };

      unitConfig = {
        StartLimitIntervalSec = 600;
        StartLimitBurst = 2;
      };
    };
  };
}
