{
  config,
  lib,
  ...
}: {
  options.myHardware.profiles.laptop.enable = lib.mkEnableOption "Laptop hardware configuration.";

  config = lib.mkMerge [
    (lib.mkIf config.myHardware.profiles.laptop.enable
      {
        services = {
          tuned.enable = lib.mkDefault true;
          upower.enable = true;
        };
      })

    (lib.mkIf ((lib.elem "kvm-intel" config.boot.kernelModules) && config.myHardware.profiles.laptop.enable) {
      # powerManagement.powertop.enable = true;
      services.thermald.enable = true;
    })

    (lib.mkIf ((lib.elem "nvidia" config.services.xserver.videoDrivers) && config.myHardware.profiles.laptop.enable) {
      hardware.nvidia = {
        dynamicBoost.enable = lib.mkDefault true;

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
