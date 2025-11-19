{
  config,
  lib,
  ...
}: {
  options.myHardware.profiles.base.enable = lib.mkEnableOption "Base common hardware configuration";

  config = lib.mkIf config.myHardware.profiles.base.enable {
    hardware = {
      enableAllFirmware = true;
      keyboard.qmk.enable = true;

      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
    };

    home-manager.sharedModules = [
      (
        {config, ...}: {
          xdg.configFile = lib.mkIf config.services.easyeffects.enable {
            "easyeffects/output/LoudnessEqualizer.json".source = ./LoudnessEqualizer.json;
            "easyeffects/output/AdvancedAutoGain.json".source = ./AdvancedAutoGain.json;
          };
        }
      )
    ];

    services = {
      fstrim.enable = true;
      usbmuxd.enable = true;
    };

    myHardware.lenovo.thinkpad.kb5D50X.enable = true;
  };
}
