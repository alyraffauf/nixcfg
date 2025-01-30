{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.hardware-amd-cpu
    self.nixosModules.hardware-amd-gpu
    self.nixosModules.hardware-common
  ];

  config = {
    boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.11") (lib.mkDefault pkgs.linuxPackages_latest);

    services = {
      handheld-daemon = {
        enable = lib.mkDefault true;

        package = with pkgs;
          handheld-daemon.overrideAttrs (oldAttrs: {
            propagatedBuildInputs =
              oldAttrs.propagatedBuildInputs
              ++ [pkgs.adjustor];
          });

        ui.enable = lib.mkDefault true;
      };

      pipewire.wireplumber.configPackages = [
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
      ];

      power-profiles-daemon.enable = lib.mkDefault true;
      upower.enable = lib.mkDefault true;
    };
  };
}
