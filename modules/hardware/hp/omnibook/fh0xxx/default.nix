{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHardware.hp.omnibook.fh0xxx.enable = lib.mkEnableOption "HP OmniBook Ultra Flip 14-fh0xx hardware configuration.";

  config = lib.mkIf config.myHardware.hp.omnibook.fh0xxx.enable {
    boot = {
      initrd.availableKernelModules = [
        "intel_ishtp_hid"
        "nvme"
        "thunderbolt"
        "xhci_pci"
      ];

      kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.16") (lib.mkDefault pkgs.linuxPackages_latest);

      boot.kernelParams =
        # Eliminates flicker on dark screens when VRR is not enabled.
        if config.myHardware.intel.gpu.driver == "xe"
        then ["xe.enable_psr=0"]
        else ["i915.enable_psr=0"];
    };

    hardware.sensor.iio.enable = true;

    home-manager.sharedModules = [
      {
        services.easyeffects = {
          enable = true;
          preset = "AdvancedAutoGain.json";
        };
      }
    ];

    nixpkgs.overlays = [
      (_final: prev: {
        linux-firmware = prev.linux-firmware.overrideAttrs (_old: {
          postInstall = ''
            cp ${./ishC_0207.bin} $out/lib/firmware/intel/ish/ish_lnlm_12128606.bin
          '';
        });
      })
    ];

    services.fprintd.enable = true;

    myHardware = {
      intel = {
        cpu.enable = true;

        gpu = {
          enable = true;
          driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") "xe";
        };
      };

      profiles = {
        base.enable = true;
        laptop.enable = true;
      };
    };
  };
}
