{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHardware.hp.omnibook.fh0xxx.dsp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.myHardware.hp.omnibook.fh0xxx.enable;

      description = ''
        Create a new audio device called "OmniBook Speakers",
        which applies sound tuning before sending the audio out to the speakers.
        This option requires PipeWire and WirePlumber.

        The filter chain includes the following:
          - Psychoacoustic bass enhancement
          - Loudness compensation
          - Slight compression

        This option has been optimised for the HP OmniBook FH0xxx series.

        Before applying, ensure the speakers are set to 100%,
        because the volumes compound and the raw speaker device will be hidden by default.

        You might also need to re-select the default output device.

        In some cases, the added bass will vibrate internal components leading to a rattling sound,
        which may require hardware adjustments to mitigate.
      '';
    };

    hideRawDevice = lib.mkOption {
      type = lib.types.bool;
      default = true;

      description = ''
        Hide the raw speaker device.
        This option is enabled by default, because keeping the raw speaker device can lead to volume conflicts.
      '';
    };

    rawDeviceName = lib.mkOption {
      type = lib.types.str;
      default = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink";

      description = ''
        The name of the raw speaker device. This will vary by device.
        You can get this by running `pw-dump | grep -C 20 pci-0000`.
      '';
    };
  };

  config = lib.mkIf config.myHardware.hp.omnibook.fh0xxx.dsp.enable (
    let
      outputName = config.myHardware.hp.omnibook.fh0xxx.dsp.rawDeviceName;
      prettyName = "OmniBook Speakers";

      json = pkgs.formats.json {};

      # The filter chain, heavily inspired by the asahi-audio project: https://github.com/AsahiLinux/asahi-audio
      filter-chain = json.generate "filter-chain.json" {
        "node.description" = prettyName;
        "media.name" = prettyName;
        "filter.graph" = {
          nodes = [
            # Psychoacoustic bass extension,
            # it creates harmonics of the missing bass to fool our ears into hearing it.
            {
              type = "lv2";
              plugin = "https://chadmed.au/bankstown";
              name = "bassex";
              control = {
                bypass = 0;
                amt = 1.2;
                sat_second = 1.3;
                sat_third = 2.5;
                blend = 1.0;
                ceil = 200.0;
                floor = 20.0;
              };
            }
            # Loudness compensation,
            # it ensures that the sound profile stays consistent across different volumes.
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/loud_comp_stereo";
              name = "el";
              control = {
                enabled = 1;
                input = 1.0;
                fft = 4;
              };
            }

            # Compressors. The settings were taken from the asahi-audio project and adapted for HP OmniBook FH0xxx.
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/mb_compressor_stereo";
              name = "woofer_bp";
              control = {
                mode = 0;
                ce_0 = 1;
                sla_0 = 5.0;
                cr_0 = 1.75;
                al_0 = 0.725;
                at_0 = 1.0;
                rt_0 = 100;
                kn_0 = 0.125;
                cbe_1 = 1;
                sf_1 = 200.0;
                ce_1 = 0;
                cbe_2 = 0;
                ce_2 = 0;
                cbe_3 = 0;
                ce_3 = 0;
                cbe_4 = 0;
                ce_4 = 0;
                cbe_5 = 0;
                ce_5 = 0;
                cbe_6 = 0;
                ce_6 = 0;
              };
            }
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/compressor_stereo";
              name = "woofer_lim";
              control = {
                sla = 5.0;
                al = 1.0;
                at = 1.0;
                rt = 100.0;
                cr = 15.0;
                kn = 0.5;
              };
            }
          ];

          # Now, we're chaining together the modules instantiated above.
          links = [
            {
              output = "bassex:out_l";
              input = "el:in_l";
            }
            {
              output = "bassex:out_r";
              input = "el:in_r";
            }

            {
              output = "el:out_l";
              input = "woofer_bp:in_l";
            }
            {
              output = "el:out_r";
              input = "woofer_bp:in_r";
            }
            {
              output = "woofer_bp:out_l";
              input = "woofer_lim:in_l";
            }
            {
              output = "woofer_bp:out_r";
              input = "woofer_lim:in_r";
            }
          ];

          inputs = [
            "bassex:in_l"
            "bassex:in_r"
          ];
          outputs = [
            "woofer_lim:out_l"
            "woofer_lim:out_r"
          ];

          # This makes pipewire's volume control actually control the loudness comp module
          "capture.volumes" = [
            {
              control = "el:volume";
              min = -47.5;
              max = 0.0;
              scale = "cubic";
            }
          ];
        };
        "capture.props" = {
          "node.name" = "audio_effect.omnibook-convolver";
          "media.class" = "Audio/Sink";
          "audio.channels" = "2";
          "audio.position" = [
            "FL"
            "FR"
          ];
          "audio.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
          "device.api" = "dsp";
          "node.virtual" = "false";

          # Lower seems to mean "more preferred",
          # bluetooth devices seem to be ~1000, speakers seem to be ~2000
          # since this is between the two, bluetooth devices take over when they connect,
          # and hand over to this instead of the raw speakers when they disconnect.
          "priority.session" = 1500;
          "priority.driver" = 1500;
          "state.default-volume" = 0.343;
          "device.icon-name" = "audio-card-analog-pci";
        };
        "playback.props" = {
          "node.name" = "audio_effect.omnibook-convolver";
          "target.object" = outputName;
          "node.passive" = "true";
          "audio.channels" = "2";
          "audio.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
          "audio.position" = [
            "FL"
            "FR"
          ];
          "device.icon-name" = "audio-card-analog-pci";
        };
      };

      configPackage =
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-omnibook.conf" ''
          monitor.alsa.rules = [
            {
              matches = [{ node.name = "${outputName}" }]
              actions = {
                update-props = {
                  audio.allowed-rates = [44100, 48000, 88200, 96000, 176400, 192000]
                }
              }
            }
          ]

          node.software-dsp.rules = [
            {
              matches = [{ node.name = "${outputName}" }]
              actions = {
                create-filter = {
                  filter-path = "${filter-chain}"
                  hide-parent = ${lib.boolToString config.myHardware.hp.omnibook.fh0xxx.dsp.hideRawDevice}
                }
              }
            }
          ]

          wireplumber.profiles = {
            main = { node.software-dsp = "required" }
          }
        '')
        // {
          passthru.requiredLv2Packages = with pkgs; [
            lsp-plugins
            bankstown-lv2
          ];
        };
    in {
      services.pipewire.wireplumber.configPackages = [configPackage];

      # Pipewire is needed for this.
      services.pipewire.enable = lib.mkDefault true;
    }
  );
}
