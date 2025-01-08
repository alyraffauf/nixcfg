{pkgs, ...}: {
  # imports = [
  #   ../programs/steam.nix
  # ];

  environment.systemPackages = with pkgs; [
    dualsensectl
    heroic
    joystickwake
    moonlight-qt
    trigger-control
  ];

  services = {
    joycond.enable = true; # For Nintendo Switch Joycons

    udev.extraRules = ''
      ## Gyro access for Pro controllers.
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"

      ## Disable DualShock 4 touchpad as mouse
      # USB
      ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      # Bluetooth
      ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"

      ## Disable DualSense touchpad as mouse
      # USB
      ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      # Bluetooth
      ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';

    switcherooControl.enable = true; # For dual GPU configs
  };
}
