{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.services.easyeffects.enable {
    xdg.configFile = {
      "easyeffects/output/framework13.json".source =
        ./framework13.json;

      "easyeffects/output/LoudnessEqualizer.json".source =
        ./LoudnessEqualizer.json;
    };

    services.easyeffects = {
      enable = true;
      preset = config.ar.home.services.easyeffects.preset;
    };
  };
}
