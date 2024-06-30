{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.defaultApps.enable {
    dconf = {
      enable = true;
      settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "${lib.getExe config.ar.home.defaultApps.terminal}";
        "org/cinnamon/desktop/default-applications/terminal".exec = "${lib.getExe config.ar.home.defaultApps.terminal}";
      };
    };

    home = {
      packages = with config.ar.home.defaultApps; [
        audioPlayer
        editor
        fileManager
        imageViewer
        pdfViewer
        terminal
        terminalEditor
        videoPlayer
        webBrowser
      ];

      sessionVariables = {
        BROWSER = "${lib.getExe config.ar.home.defaultApps.webBrowser}";
        EDITOR = "${lib.getExe config.ar.home.defaultApps.terminalEditor}";
        TERMINAL = "${lib.getExe config.ar.home.defaultApps.terminal}";
      };
    };

    xdg = {
      mimeApps = {
        enable = true;

        defaultApplications = {
          "application/json" = "defaultEditor.desktop";
          "application/pdf" = "defaultPdfViewer.desktop";
          "application/x-extension-htm" = "defaultWebBrowser.desktop";
          "application/x-extension-html" = "defaultWebBrowser.desktop";
          "application/x-extension-shtml" = "defaultWebBrowser.desktop";
          "application/x-extension-xht" = "defaultWebBrowser.desktop";
          "application/x-extension-xhtml" = "defaultWebBrowser.desktop";
          "application/x-shellscript" = "defaultEditor.desktop";
          "application/xhtml+xml" = "defaultWebBrowser.desktop";
          "audio/aac" = "defaultAudioPlayer.desktop";
          "audio/flac" = "defaultAudioPlayer.desktop";
          "audio/mpeg" = "defaultAudioPlayer.desktop";
          "audio/ogg" = "defaultAudioPlayer.desktop";
          "audio/opus" = "defaultAudioPlayer.desktop";
          "audio/wav" = "defaultAudioPlayer.desktop";
          "audio/webm" = "defaultAudioPlayer.desktop";
          "image/gif" = "defaultImageViewer.desktop";
          "image/jpeg" = "defaultImageViewer.desktop";
          "image/png" = "defaultImageViewer.desktop";
          "image/svg+xml" = "defaultImageViewer.desktop";
          "image/tiff" = "defaultImageViewer.desktop";
          "image/webp" = "defaultImageViewer.desktop";
          "inode/directory" = "defaultFileManager.desktop";
          "text/html" = "defaultWebBrowser.desktop";
          "text/markdown" = "defaultEditor.desktop";
          "text/plain" = "defaultEditor.desktop";
          "text/x-python" = "defaultEditor.desktop";
          "text/xml" = "defaultWebBrowser.desktop";
          "video/mp2t" = "defaultVideoPlayer.desktop";
          "video/mp4" = "defaultVideoPlayer.desktop";
          "video/mpeg" = "defaultVideoPlayer.desktop";
          "video/ogg" = "defaultVideoPlayer.desktop";
          "video/webm" = "defaultVideoPlayer.desktop";
          "video/x-msvideo" = "defaultVideoPlayer.desktop";
          "x-scheme-handler/chrome" = "defaultWebBrowser.desktop";
          "x-scheme-handler/ftp" = "defaultWebBrowser.desktop";
          "x-scheme-handler/http" = "defaultWebBrowser.desktop";
          "x-scheme-handler/https" = "defaultWebBrowser.desktop";
        };
      };

      desktopEntries = let
        mkDefaultEntry = name: package: {
          name = "Default ${name}";
          exec = "${lib.getExe package} %U";
          terminal = false;
          settings = {
            NoDisplay = "true";
          };
        };
      in {
        defaultAudioPlayer = mkDefaultEntry "Audio Player" config.ar.home.defaultApps.audioPlayer;
        defaultEditor = mkDefaultEntry "Editor" config.ar.home.defaultApps.editor;
        defaultFileManager = mkDefaultEntry "File Manager" config.ar.home.defaultApps.fileManager;
        defaultImageViewer = mkDefaultEntry "Image Viewer" config.ar.home.defaultApps.imageViewer;
        defaultPdfViewer = mkDefaultEntry "PDF Viewer" config.ar.home.defaultApps.pdfViewer;
        defaultVideoPlayer = mkDefaultEntry "Video Player" config.ar.home.defaultApps.videoPlayer;
        defaultWebBrowser = mkDefaultEntry "Web Browser" config.ar.home.defaultApps.webBrowser;
      };
    };
  };
}
