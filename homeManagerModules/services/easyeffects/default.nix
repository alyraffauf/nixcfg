{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.services.easyeffects.enable =
      lib.mkEnableOption "EasyEffects user service.";
    alyraffauf.services.easyeffects.preset = lib.mkOption {
      description = "Name of preset to start with.";
      default = "";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.alyraffauf.services.easyeffects.enable {
    xdg.configFile."easyeffects/output/framework13.json".source =
      ./framework13.json;

    xdg.configFile."easyeffects/output/LoudnessEqualizer.json".source =
      ./LoudnessEqualizer.json;

    services.easyeffects = {
      enable = true;
      preset = config.alyraffauf.services.easyeffects.preset;
    };
  };
}
