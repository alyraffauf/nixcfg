{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.fractal.enable =
      lib.mkEnableOption "Enables Fractal Matrix client.";
  };

  config = lib.mkIf config.alyraffauf.apps.fractal.enable {
    home.packages = with pkgs; [fractal];
  };
}
