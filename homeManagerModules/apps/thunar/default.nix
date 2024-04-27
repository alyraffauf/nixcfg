{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.thunar.enable = lib.mkEnableOption "Enable thunar.";};

  config = lib.mkIf config.alyraffauf.apps.thunar.enable {
    home.packages = with pkgs; [
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
      xfce.exo
      xfce.tumbler
    ];

    xdg.configFile."xfce4/helpers.rc".text = ''
      TerminalEmulator=alacritty
      FileManager=thunar
      WebBrowser=firefox
    '';

    xfconf.settings = {
      thunar = {
        "last-menubar-visible" = false;
        "misc-confirm-close-multiple-tabs" = false;
        "misc-show-delete-action" = true;
        "misc-single-click" = true;
      };
    };
  };
}
