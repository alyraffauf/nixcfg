{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.defaultApps.enable {
    home.packages = with config.alyraffauf.defaultApps; [
      audioPlayer.package
      editor.package
      imageViewer.package
      pdfEditor.package
      terminalEditor.package
      videoPlayer.package
      webBrowser.package
    ];
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = config.alyraffauf.defaultApps.pdfEditor.desktop;
        "application/x-shellscript" = config.alyraffauf.defaultApps.editor.desktop;
        "application/xhtml+xml" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "audio/flac" = config.alyraffauf.defaultApps.audioPlayer.desktop;
        "audio/mpeg" = config.alyraffauf.defaultApps.audioPlayer.desktop;
        "audio/opus" = config.alyraffauf.defaultApps.audioPlayer.desktop;
        "image/jpeg" = config.alyraffauf.defaultApps.imageViewer.desktop;
        "image/png" = config.alyraffauf.defaultApps.imageViewer.desktop;
        "text/html" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "text/plain" = config.alyraffauf.defaultApps.editor.desktop;
        "text/x-python" = config.alyraffauf.defaultApps.editor.desktop;
        "text/xml" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "video/H264" = config.alyraffauf.defaultApps.videoPlayer.desktop;
        "video/mp4" = config.alyraffauf.defaultApps.videoPlayer.desktop;
        "video/mpeg" = config.alyraffauf.defaultApps.videoPlayer.desktop;
        "video/ogg" = config.alyraffauf.defaultApps.videoPlayer.desktop;
        "video/x-matroska" = config.alyraffauf.defaultApps.videoPlayer.desktop;
        "x-scheme-handler/ftp" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "x-scheme-handler/http" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "x-scheme-handler/https" = config.alyraffauf.defaultApps.webBrowser.desktop;
      };
    };
    home.sessionVariables = {
      BROWSER = "${config.alyraffauf.defaultApps.webBrowser.exe}";
      EDITOR = "${config.alyraffauf.defaultApps.terminalEditor.exe}";
      TERMINAL = "${config.alyraffauf.defaultApps.terminal.exe}";
    };
  };
}
