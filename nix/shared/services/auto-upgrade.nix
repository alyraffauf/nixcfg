_: let
  autoUpgrade = flakeReference: {
    enable = true;
    dates = "02:00";
    fixedRandomDelay = true;
    flake = flakeReference;
    flags = ["--accept-flake-config"];
    persistent = true;
    randomizedDelaySec = "45min";
  };

  upgradeService = serviceName: {
    ${serviceName} = {
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
in {
  flake = {
    nixosModules.default = {config, ...}: {
      system.autoUpgrade =
        (autoUpgrade "github:alyraffauf/hoenn#${config.networking.hostName}")
        // {
          allowReboot = false;
          operation = "boot";
          upgrade = false;
        };

      systemd.services = upgradeService "nixos-upgrade";
    };

    darwinModules.default = {
      config,
      lib,
      ...
    }: let
      maxAttempts = 3;
      randomizedDelaySeconds = 45 * 60;
      retryDelaySeconds = 15 * 60;
    in {
      launchd.daemons.nix-darwin-upgrade = {
        script = ''
          set -eu

          random_delay="$(( $(/usr/bin/printf '%s' ${lib.escapeShellArg config.networking.hostName} | /usr/bin/cksum | /usr/bin/awk '{ print $1 }') % ${toString randomizedDelaySeconds} ))"
          /bin/sleep "$random_delay"

          for attempt in $(/usr/bin/jot 1 ${toString maxAttempts}); do
            if ${config.system.build.darwin-rebuild}/bin/darwin-rebuild switch --accept-flake-config --flake ${lib.escapeShellArg "github:alyraffauf/hoenn#${config.networking.hostName}"} --refresh; then
              exit 0
            fi

            if [ "$attempt" -lt ${toString maxAttempts} ]; then
              /bin/sleep ${toString retryDelaySeconds}
            fi
          done

          exit 1
        '';

        serviceConfig = {
          ProcessType = "Background";
          RunAtLoad = false;
          StandardErrorPath = "/var/log/nix-darwin-upgrade.log";
          StandardOutPath = "/var/log/nix-darwin-upgrade.log";
          StartCalendarInterval = {
            Hour = 2;
            Minute = 0;
          };
        };
      };
    };

    systemModules.default = {
      system.autoUpgrade = autoUpgrade "github:alyraffauf/hoenn#systemConfigs.sootopolis";
      systemd.services = upgradeService "system-manager-upgrade";
    };
  };
}
