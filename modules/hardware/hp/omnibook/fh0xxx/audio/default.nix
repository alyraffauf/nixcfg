{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHardware.hp.omnibook.fh0xxx.audio = {
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
          - Audio suspend disabled to prevent popping

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

  config = lib.mkIf config.myHardware.hp.omnibook.fh0xxx.audio.enable (
    let
      cfg = config.myHardware.hp.omnibook.fh0xxx.audio;
      outputName = cfg.rawDeviceName;

      # Read the shared filter chain template and substitute the device name
      filter-chain-template = builtins.readFile ./omnibook-fh0xxx-filter-chain.json;
      filter-chain = pkgs.writeText "omnibook-fh0xxx-filter-chain.json" (
        builtins.replaceStrings
        ["@DEVICE_NAME@"]
        [outputName]
        filter-chain-template
      );

      # Read the shared wireplumber config template and substitute variables
      wireplumber-template = builtins.readFile ./99-omnibook.conf;
      wireplumber-conf =
        builtins.replaceStrings
        ["@DEVICE_NAME@" "@HIDE_PARENT@" "@FILTER_PATH@"]
        [outputName (lib.boolToString cfg.hideRawDevice) "${filter-chain}"]
        wireplumber-template;

      configPackage =
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-omnibook.conf" wireplumber-conf)
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
