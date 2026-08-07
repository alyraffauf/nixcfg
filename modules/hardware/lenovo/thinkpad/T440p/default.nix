{
  config,
  lib,
  ...
}: {
  options.myHardware.lenovo.thinkpad.T440p = {
    enable = lib.mkEnableOption "Lenovo ThinkPad T440p hardware configuration.";

    equalizer = lib.mkOption {
      type = lib.types.bool;
      default = config.myHardware.lenovo.thinkpad.T440p.enable;
      description = "Enable EasyEffects equalizer preset for Lenovo ThinkPad T440p.";
    };
  };

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

    hardware = {
      enableAllFirmware = true;

      trackpoint = {
        enable = true;
        emulateWheel = true;
        sensitivity = 64;
        speed = 40;
      };
    };

    home-manager = {
      sharedModules = [
        (lib.mkIf config.myHardware.lenovo.thinkpad.T440p.equalizer
          {
            services.easyeffects = {
              enable = true;
              preset = "T440p.json";
            };

            xdg.configFile."easyeffects/output/T440p.json".source = ./easyeffects.json;
          })
      ];
    };

    powerManagement.cpuFreqGovernor = "ondemand";

    myHardware = {
      intel = {
        cpu.enable = true;
        gpu.enable = true;
      };

      profiles = {
        laptop.enable = true;
        ssd.enable = true;
      };
    };
  };
}
