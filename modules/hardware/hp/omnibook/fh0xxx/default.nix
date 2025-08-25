{
  config,
  lib,
  ...
}: {
  options.myHardware.hp.omnibook.fh0xxx.enable = lib.mkEnableOption "HP OmniBook Ultra Flip 14-fh0xx hardware configuration.";

  config = lib.mkIf config.myHardware.hp.omnibook.fh0xxx.enable {
    boot.initrd.availableKernelModules = [
      "intel_ishtp_hid"
      "nvme"
      "thunderbolt"
      "xhci_pci"
    ];

    hardware.sensor.iio.enable = true;

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
        gpu.enable = true;
      };

      profiles = {
        base.enable = true;
        laptop.enable = true;
      };
    };
  };
}
