{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    guiApps.fractal.enable =
      lib.mkEnableOption "Enables Fractal Matrix client.";
  };

  config = lib.mkIf config.guiApps.fractal.enable {
    home.packages = with pkgs; [fractal];
  };
}
