{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.thunar.enable {
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
