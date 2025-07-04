{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.cosmic.enable = lib.mkEnableOption "COSMIC desktop environment";

  config = lib.mkIf config.myHome.desktop.cosmic.enable {
    myHome.profiles.defaultApps = {
      audioPlayer.package = lib.mkDefault pkgs.rhythmbox;
      editor.package = lib.mkDefault pkgs.cosmic-edit;
      fileManager.package = lib.mkDefault pkgs.cosmic-files;
      imageViewer.package = lib.mkDefault pkgs.loupe;
      pdfViewer.package = lib.mkDefault pkgs.evince;
      terminal.package = lib.mkDefault pkgs.cosmic-term;
      videoPlayer.package = lib.mkDefault pkgs.cosmic-player;
    };
  };
}
