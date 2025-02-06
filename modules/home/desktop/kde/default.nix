{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.kde.enable = lib.mkEnableOption "KDE desktop environment";

  config = lib.mkIf config.myHome.desktop.kde.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
      };
    };

    myHome.profiles.defaultApps = {
      audioPlayer = lib.mkDefault pkgs.kdePackages.dragon;
      editor = lib.mkDefault pkgs.kdePackages.kate;
      fileManager = lib.mkDefault pkgs.kdePackages.dolphin;
      imageViewer = lib.mkDefault pkgs.kdePackages.gwenview;
      pdfViewer = lib.mkDefault pkgs.kdePackages.okular;
      terminal = lib.mkDefault pkgs.kdePackages.konsole;
      videoPlayer = lib.mkDefault pkgs.kdePackages.dragon;
    };
  };
}
