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

    stylix.targets.qt.enable = lib.mkForce false;

    myHome.profiles.defaultApps = {
      audioPlayer.package = lib.mkDefault pkgs.kdePackages.dragon;
      editor.package = lib.mkDefault pkgs.kdePackages.kate;

      fileManager = {
        package = lib.mkDefault pkgs.kdePackages.dolphin;
        exec = lib.mkDefault (
          if config.myHome.profiles.defaultApps.fileManager.package == pkgs.kdePackages.dolphin
          then "dolphin"
          else (lib.getExe config.myHome.profiles.defaultApps.fileManager.package)
        );
      };

      imageViewer.package = lib.mkDefault pkgs.kdePackages.gwenview;
      pdfViewer.package = lib.mkDefault pkgs.kdePackages.okular;
      terminal.package = lib.mkDefault pkgs.kdePackages.konsole;
      videoPlayer.package = lib.mkDefault pkgs.kdePackages.dragon;
    };
  };
}
