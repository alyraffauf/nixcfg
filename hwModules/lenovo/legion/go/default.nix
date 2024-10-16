{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  legion-go-tricks = pkgs.fetchFromGitHub {
    owner = "aarron-lee";
    repo = "legion-go-tricks";
    rev = "773f4dfa217989213ab2678d63a84dc306e8f8d4";
    sha256 = "sha256-d5TB4kvNR7bwF5VyO1hxe8n9/PubtzWlBgvSmpUgDQc=";
  };

  convolverPath = "${legion-go-tricks}/experimental_sound_fix/multiwayCor48.wav";
in {
  imports = [
    self.nixosModules.hw-common-amd-cpu
    self.nixosModules.hw-common-amd-gpu
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "amdgpu"
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "sdhci_pci"
        "thunderbolt"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];

      kernelModules = ["amdgpu"];
    };

    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = with config.boot.kernelPackages; [acpi_call zenpower];
    kernelModules = ["zenpower"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
  };

  hardware = {
    enableAllFirmware = true;
    sensor.iio.enable = true;
  };

  services = {
    pipewire.wireplumber.configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-legion-go-convolver.conf" ''
        # Convolver Configuration for Pipewire
        #
        # This configuration applies separate left and right convolver effects using the corresponding impulse response files
        # to the entire system audio output.

        context.modules = [
            { name = libpipewire-module-filter-chain
                args = {
                    node.description = "Legion Go"
                    media.name       = "Legion Go"
                    filter.graph = {
                        nodes = [
                            {
                                type  = builtin
                                label = convolver
                                name  = convFL
                                config = {
                                    filename = "${convolverPath}"
                                    channel  = 0
                                }
                            }
                            {
                                type  = builtin
                                label = convolver
                                name  = convFR
                                config = {
                                    filename = "${convolverPath}"
                                    channel  = 1
                                }
                            }
                        ]
                        inputs = [ "convFL:In" "convFR:In" ]
                        outputs = [ "convFL:Out" "convFR:Out" ]
                    }
                    capture.props = {
                        node.name        = "Legion Go"
                        node.autoconnect = true
                        media.class      = "Audio/Sink"
                        priority.driver  = 1000
                        priority.session = 2000
                        audio.channels   = 2
                        audio.position   = [ FL FR ]
                    }
                    playback.props = {
                        node.name      = "Legion Go corrected"
                        node.passive   = true
                        audio.channels = 2
                        audio.position = [ FL FR ]
                        node.target    = "alsa_output.pci-0000_c2_00.6.analog-stereo"
                    }
                }
            }
        ]
      '')
    ];

    upower.enable = true;
  };
}
