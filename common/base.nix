{lib, ...}: {
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  console.useXkbConfig = true;
  hardware.keyboard.qmk.enable = true;

  programs = {
    dconf.enable = true; # Needed for home-manager

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nh.enable = true;
  };

  networking.networkmanager.enable = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;

      publish = {
        enable = true;
        addresses = true;
        userServices = true;
        workstation = true;
      };
    };

    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
    };

    openssh = {
      enable = true;
      openFirewall = true;
      settings.PasswordAuthentication = false;
    };

    udev.extraRules = ''
      # Disable Fn Lock for ThinkPad Trackpoint USB/Bluetooth Keyboard
      SUBSYSTEM=="hid", DRIVER=="lenovo", ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6047|60ee", ATTR{fn_lock}="0"
      SUBSYSTEM=="input", ATTRS{id/vendor}=="17ef", ATTRS{id/product}=="6048|60e1", TEST=="/sys/$devpath/device/fn_lock", RUN+="/bin/sh -c 'echo 0 > \"/sys/$devpath/device/fn_lock\"'"
    '';
  };

  sound.enable = true;

  zramSwap = {
    enable = lib.mkDefault true;
    memoryPercent = lib.mkDefault 50;
  };
}
