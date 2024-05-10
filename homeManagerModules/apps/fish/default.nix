{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.fish.enable = lib.mkEnableOption "Enables fish.";};

  config = lib.mkIf config.alyraffauf.apps.fish.enable {
    programs.fish = {
      enable = true;
    };
  };
}
