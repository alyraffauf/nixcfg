{
  config,
  lib,
  ...
}: {
  options.myHardware.lenovo.thinkpad.T440p.enable = lib.mkEnableOption "Lenovo ThinkPad T440p hardware configuration.";

  config = lib.mkIf config.myHardware.lenovo.thinkpad.T440p.enable {
    boot = {
      extraModprobeConfig = ''
        options bbswitch use_acpi_to_detect_card_state=1
        options thinkpad_acpi force_load=1 fan_control=1
      '';

      initrd.availableKernelModules = [
        "ahci"
        "ehci_pci"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "sr_mod"
        "usb_storage"
        "xhci_pci"
      ];
    };

    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
      sensitivity = 64;
      speed = 40;
    };

    home-manager = {
      sharedModules = [
        {
          services.easyeffects = {
            enable = true;
            preset = "T440p.json";
          };

          xdg.configFile."easyeffects/output/T440p.json".source = ./easyeffects.json;
        }
      ];
    };

    powerManagement.cpuFreqGovernor = "ondemand";
    services.fwupd.enable = true;
    zramSwap.algorithm = "lz4";

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
