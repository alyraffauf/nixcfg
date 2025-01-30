{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      dualsensectl
      heroic
      joystickwake
      moonlight-qt
      trigger-control
    ];

    services = {
      joycond.enable = true; # For Nintendo Switch Joycons

      pipewire.wireplumber.configPackages = [
        pkgs.writeTextDir
        "share/wireplumber/wireplumber.conf.d/alsa-ps-controller.conf"
        # From https://github.com/ublue-os/bazzite/blob/13d4a51aae79e7f78bc7c26e9f8953f140d959f7/system_files/deck/shared/usr/share/wireplumber/wireplumber.conf.d/alsa-ps-controller.conf
        ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  node.name = "~alsa_input.*"
                  alsa.card_name = "Wireless Controller"
                }
                {
                  node.name = "~alsa_output.*"
                  alsa.card_name = "Wireless Controller"
                }
              ]
              actions = {
                update-props = {
                  priority.driver        = 90
                  priority.session       = 90
                }
              }
            }
          ]
        ''
      ];

      udev.extraRules = ''
        ## Gyro access for Switch Pro controllers.
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"

        ## Disable DualShock 4 touchpad as mouse.
        # USB
        ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        # Bluetooth
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        ## Disable DualSense touchpad as mouse.
        # USB
        ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        # Bluetooth
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';

      switcherooControl.enable = true; # For dual GPU configs
    };
  };
}
