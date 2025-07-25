# Lenovo 5D50X AKA ThinkPad Trackpoint II USB/Bluetooth Keyboard.
{
  config,
  lib,
  ...
}: {
  options.myHardware.lenovo.thinkpad.kb5D50X.enable = lib.mkEnableOption "Lenovo ThinkPad 5D50X hardware configuration.";

  config = lib.mkIf config.myHardware.lenovo.thinkpad.kb5D50X.enable {
    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
      sensitivity = 64;
      speed = 40;
    };

    services.udev.extraRules = ''
      ## Handle Fn Lock light for ThinkPad Trackpoint II USB/Bluetooth Keyboard
      SUBSYSTEM=="hid", DRIVER=="lenovo", ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6047|60ee", ATTR{fn_lock}="0"
      SUBSYSTEM=="input", ATTRS{id/vendor}=="17ef", ATTRS{id/product}=="6048|60e1", TEST=="/sys/$devpath/device/fn_lock", RUN+="/bin/sh -c 'echo 0 > \"/sys/$devpath/device/fn_lock\"'"
    '';
  };
}
