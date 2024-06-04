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
      xfce.xfconf
    ];

    xdg.configFile."xfce4/helpers.rc".text = ''
      FileManager=thunar
      TerminalEmulator=alacritty
      WebBrowser=firefox
    '';
  };
}
