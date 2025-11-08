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

      kernelParams = lib.mkIf (lib.versionOlder pkgs.linux.version "6.17") (
        # Eliminates flicker on dark screens when VRR is not enabled.
        # Seems to be fixed in linux >= 6.17.
        if config.myHardware.intel.gpu.driver == "xe"
        then ["xe.enable_psr=0"]
        else ["i915.enable_psr=0"]
      );
    };

    hardware.sensor.iio.enable = true;

    home-manager.sharedModules = [
      {
        services.easyeffects = {
          # Adds DSP for the included speakers.
          enable = true;
          preset = "AdvancedAutoGain.json";
        };
      }
    ];

    nixpkgs.overlays = [
      (_final: prev: {
        # linux-firmware = prev.linux-firmware.overrideAttrs (_old: {
        #   # Adds Intel ISH firmware for various accelerometers + tablet mode.
        #   postInstall = ''
        #     cp ${./ishC_0207.bin} $out/lib/firmware/intel/ish/ish_lnlm_12128606.bin
        #   '';
        # });
        #
        linux-firmware = prev.linux-firmware.overrideAttrs (_oldAttrs: {
          src = builtins.fetchGit {
            url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
            rev = "b918d0b3cb97a9a93fe9f48459ee61d4a10bf64d";
          };

          version = "b918d0b3cb97a9a93fe9f48459ee61d4a10bf64d";
        });
      })
    ];

    services.fprintd.enable = true;

    myHardware = {
      intel = {
        cpu.enable = true;

        gpu = {
          enable = true;

          driver = lib.mkIf (
            lib.versionAtLeast
            config.boot.kernelPackages.kernel.version "6.8"
            # You probably don't want to run this laptop on a kernel this old.
          ) "xe";
        };
      };

      profiles = {
        base.enable = true;
        laptop.enable = true;
      };
    };
  };
}
