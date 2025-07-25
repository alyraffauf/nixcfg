{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHardware.asus.ally.RC72LA.enable = lib.mkEnableOption "ASUS Ally X RC72LA hardware configuration.";

  config = lib.mkIf config.myHardware.asus.ally.RC72LA.enable {
    boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.11") (lib.mkDefault pkgs.linuxPackages_latest);

    services = {
      handheld-daemon = {
        enable = lib.mkDefault true;
        ui.enable = lib.mkDefault true;
      };

      pipewire.wireplumber.configPackages = [
        (
          pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa-card0.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  {
                    node.name = "alsa_output.pci-0000_64_00.6.analog-stereo"
                  }
                ]
                actions = {
                  update-props = {
                    priority.driver        = 900
                    priority.session       = 900
                    api.alsa.period-size   = 256
                    api.alsa.headroom      = 1024
                    session.suspend-timeout-seconds = 0
                  }
                }
              }
            ]
          ''
        )
        (
          pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa-card1.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  {
                    node.name = "~alsa_input.*"
                    alsa.card_name = "acp5x"
                  }
                  {
                    node.name = "~alsa_input.*"
                    alsa.card_name = "acp6x"
                  }
                  {
                    node.name = "~alsa_input.*"
                    alsa.card_name = "sof-nau8821-max"
                  }
                  {
                    node.name = "~alsa_output.*"
                    alsa.card_name = "acp5x"
                  }
                  {
                    node.name = "~alsa_output.*"
                    alsa.card_name = "acp6x"
                  }
                  {
                    node.name = "~alsa_output.*"
                    alsa.card_name = "sof-nau8821-max"
                  }
                ]
                actions = {
                  update-props = {
                    session.suspend-timeout-seconds   = 0
                    api.alsa.headroom      = 1024
                  }
                }
              }
            ]
          ''
        )
        (
          pkgs.writeTextDir
          "share/wireplumber/wireplumber.conf.d/51-preferHDMI.conf"
          ''
            monitor.alsa.rules = [
              {
                matches = [
                  {
                    node.name = "alsa_output.pci-0000_64_00.1.hdmi-stereo"
                  }
                ]
                actions = {
                  update-props = {
                    priority.driver = 1100
                    priority.session = 1100
                  }
                }
              }
            ]
          ''
        )
      ];

      power-profiles-daemon.enable = lib.mkDefault true;
      upower.enable = lib.mkDefault true;
    };

    myHardware = {
      amd = {
        cpu.enable = true;
        gpu.enable = true;
      };

      profiles.base.enable = true;
    };
  };
}
