{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.budgie.enable =
      lib.mkEnableOption "Budgie with sane defaults.";
  };

  config = lib.mkIf config.alyraffauf.desktop.budgie.enable {
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
      "org/gnome/desktop/peripherals/touchpad".natural-scroll = true;
    };
  };
}
