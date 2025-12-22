# Adapted from https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch/common/audio.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHardware.lenovo.thinkpad.X1.gen-7.audio;
in {
  options = {
    myHardware.lenovo.thinkpad.X1.gen-7.audio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.myHardware.lenovo.thinkpad.X1.gen-7.enable;
        description = ''
          Create a new audio device called "ThinkPad Speakers",
          which applies sound tuning before sending the audio out to the speakers.
          This option requires PipeWire and WirePlumber.

          The filter chain includes the following:
            - Psychoacoustic bass enhancement
            - Loudness compensation
            - Equalizer
            - Slight compression

          This option has been optimised for the ThinkPad X1 Carbon Gen 7 series, but should work on all models.

          Before applying, ensure the speakers are set to 100%,
          because the volumes compound and the raw speaker device will be hidden by default.

          You might also need to re-select the default output device.

          In some cases, the added bass will vibrate the keyboard cable leading to a rattling sound,
          a piece of foam can be used to mitigate this.
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
        example = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink";
        description = ''
          The name of the raw speaker device. This will vary by device.
          You can get this by running `pw-dump | grep -C 20 pci-0000`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (let
    outputName = cfg.rawDeviceName;

    # These are pre-made decibel to linear value conversions, since Nix doesn't have pow().
    # Use the formula `10 ** (db / 20)` to calculate.
    # Read the shared filter chain template and substitute the device name
    filter-chain-template = builtins.readFile ./x1c-gen9-filter-chain.json;
    filter-chain = pkgs.writeText "x1c-gen9-filter-chain.json" (
      builtins.replaceStrings
      ["@DEVICE_NAME@"]
      [outputName]
      filter-chain-template
    );

    # Read the shared wireplumber config template and substitute variables
    wireplumber-template = builtins.readFile ./99-x1c.conf;
    wireplumber-conf =
      builtins.replaceStrings
      ["@DEVICE_NAME@" "@HIDE_PARENT@" "@FILTER_PATH@"]
      [outputName (lib.boolToString cfg.hideRawDevice) "${filter-chain}"]
      wireplumber-template;

    configPackage =
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-x1c.conf" wireplumber-conf)
      // {
        passthru.requiredLv2Packages = with pkgs; [
          lsp-plugins
          bankstown-lv2
        ];
      };
  in {
    services.pipewire = {
      enable = true;
      wireplumber.configPackages = [configPackage];
    };
  });
}
