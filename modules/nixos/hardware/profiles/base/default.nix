{
  config,
  lib,
  ...
}: {
  options.myHardware.profiles.base.enable = lib.mkEnableOption "Base common hardware configuration";

  config = lib.mkIf config.myHardware.profiles.base.enable {
    console.useXkbConfig = true;

    hardware = {
      enableAllFirmware = true;

      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      keyboard.qmk.enable = true;

      logitech.wireless = {
        enable = true;
        enableGraphical = lib.mkDefault config.services.xserver.enable;
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

      logind = {
        powerKey = "suspend";
        powerKeyLongPress = "poweroff";
      };

      xserver.xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    zramSwap.enable = lib.mkDefault true;
    myHardware.lenovo.thinkpad.kb5D50X.enable = true;
  };
}
