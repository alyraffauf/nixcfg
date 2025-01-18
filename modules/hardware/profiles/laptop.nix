{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    {
      boot.kernel.sysctl = {
        "kernel.nmi_watchdog" = lib.mkDefault 0;
      };

      services = {
        power-profiles-daemon.enable = lib.mkDefault true;

        udev.extraRules = ''
          ## Switch power profiles based on AC power status.
          SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="1", ACTION=="change", RUN+="${lib.getExe pkgs.power-profiles-daemon} set balanced"
          SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="0", ACTION=="change", RUN+="${lib.getExe pkgs.power-profiles-daemon} set power-saver"
        '';

        upower.enable = lib.mkDefault true;
      };
    }

    (lib.mkIf (lib.elem "kvm-intel" config.boot.kernelModules) {
      powerManagement.powertop.enable = true;
      services.thermald.enable = true;
    })

    (lib.mkIf (lib.elem "nvidia" config.services.xserver.videoDrivers) {
      hardware.nvidia = {
        powerManagement = {
          enable = true;
          finegrained = true;
        };

        prime.offload = {
          # Remember to define nvidiaBusId and intelBusId/amdBusId in config.hardware.nvidia.prime.
          enable = true;
          enableOffloadCmd = true;
        };
      };

      specialisation.nvidia-sync.configuration = {
        environment.etc."specialisation".text = "nvidia-sync";

        hardware.nvidia = {
          powerManagement = {
            enable = lib.mkForce false;
            finegrained = lib.mkForce false;
          };

          prime = {
            offload = {
              enable = lib.mkForce false;
              enableOffloadCmd = lib.mkForce false;
            };

            sync.enable = lib.mkForce true;
          };
        };
      };
    })
  ];
}
