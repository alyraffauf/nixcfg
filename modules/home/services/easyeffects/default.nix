{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.myHome.services.easyeffects.enable {
    xdg.configFile = {
      "easyeffects/output/framework13.json".source = ./framework13.json;
      "easyeffects/output/fw13-autogain.json".source = ./fw13-autogain.json;
      "easyeffects/output/fw13-easy-effects.json".source = ./framework13.json;
      "easyeffects/output/LoudnessEqualizer.json".source = ./LoudnessEqualizer.json;
      "easyeffects/output/AdvancedAutoGain.json".source = ./AdvancedAutoGain.json;
    };

    services.easyeffects = {
      enable = true;
      preset = config.myHome.services.easyeffects.preset;
    };
  };
}
