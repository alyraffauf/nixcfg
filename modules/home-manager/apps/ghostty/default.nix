{
  config,
  lib,
  ...
}: let
  cfg = config.myHome;
in {
  config = lib.mkIf cfg.apps.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
