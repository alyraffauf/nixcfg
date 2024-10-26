{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.desktop.kde.enable {
    home.packages = with pkgs; [maliit-keyboard];

    dconf = {
      enable = true;

      settings = {
        "org.maliit.keyboard.maliit" = {
          key-press-haptic-feedback = true;
          theme = "BreezeDark";
        };
      };
    };
  };
}
