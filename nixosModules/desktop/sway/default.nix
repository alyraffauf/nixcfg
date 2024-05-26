{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.sway.enable =
      lib.mkEnableOption "Sway wayland compositor.";
  };

  config = lib.mkIf config.alyraffauf.desktop.sway.enable {
    alyraffauf.desktop.waylandComp.enable = true;

    programs = {
      sway = {
        enable = true;
        package = inputs.nixpkgsUnstable.legacyPackages."${pkgs.system}".swayfx;
      };
    };
  };
}
