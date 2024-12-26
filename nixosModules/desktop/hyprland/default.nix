{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.desktop.hyprland.enable {
    programs = {
      hyprland.enable = true;
      hyprlock.enable = true;
    };
  };
}
