_: {
  flake.nixosModules.default = {pkgs, ...}: {
    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
      sensitivity = 64;
      speed = 40;
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="hid", DRIVER=="lenovo", ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6047", ATTR{fn_lock}="0"
      SUBSYSTEM=="hid", DRIVER=="lenovo", ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="60ee", ATTR{fn_lock}="0"
      SUBSYSTEM=="input", ATTRS{id/vendor}=="17ef", ATTRS{id/product}=="6048", TEST=="/sys/$devpath/device/fn_lock", RUN+="${pkgs.runtimeShell} -c 'echo 0 > \"/sys/$devpath/device/fn_lock\"'"
      SUBSYSTEM=="input", ATTRS{id/vendor}=="17ef", ATTRS{id/product}=="60e1", TEST=="/sys/$devpath/device/fn_lock", RUN+="${pkgs.runtimeShell} -c 'echo 0 > \"/sys/$devpath/device/fn_lock\"'"
    '';
  };
}
