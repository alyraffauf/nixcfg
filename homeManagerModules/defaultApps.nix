{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.defaultApps.enable {
    home.packages = with config.ar.home.defaultApps; [
      audioPlayer.package
      editor.package
      fileManager.package
      imageViewer.package
      pdfViewer.package
      terminal.package
      terminalEditor.package
      videoPlayer.package
      webBrowser.package
    ];

    dconf = {
      enable = true;
      settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "${config.ar.home.defaultApps.terminal.exe}";
        "org/cinnamon/desktop/default-applications/terminal".exec = "${config.ar.home.defaultApps.terminal.exe}";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = config.ar.home.defaultApps.editor.desktop;
        "application/pdf" = config.ar.home.defaultApps.pdfViewer.desktop;
        "application/x-extension-htm" = config.ar.home.defaultApps.webBrowser.desktop;
        "application/x-extension-html" = config.ar.home.defaultApps.webBrowser.desktop;
        "application/x-extension-shtml" = config.ar.home.defaultApps.webBrowser.desktop;
        "application/x-extension-xht" = config.ar.home.defaultApps.webBrowser.desktop;
        "application/x-extension-xhtml" = config.ar.home.defaultApps.webBrowser.desktop;
        "application/x-shellscript" = config.ar.home.defaultApps.editor.desktop;
        "application/xhtml+xml" = config.ar.home.defaultApps.webBrowser.desktop;
        "audio/*" = config.ar.home.defaultApps.audioPlayer.desktop;
        "image/*" = config.ar.home.defaultApps.imageViewer.desktop;
        "inode/directory" = config.ar.home.defaultApps.fileManager.desktop;
        "text/html" = config.ar.home.defaultApps.webBrowser.desktop;
        "text/markdown" = config.ar.home.defaultApps.editor.desktop;
        "text/plain" = config.ar.home.defaultApps.editor.desktop;
        "text/x-python" = config.ar.home.defaultApps.editor.desktop;
        "text/xml" = config.ar.home.defaultApps.webBrowser.desktop;
        "video/*" = config.ar.home.defaultApps.videoPlayer.desktop;
        "x-scheme-handler/chrome" = config.ar.home.defaultApps.webBrowser.desktop;
        "x-scheme-handler/ftp" = config.ar.home.defaultApps.webBrowser.desktop;
        "x-scheme-handler/http" = config.ar.home.defaultApps.webBrowser.desktop;
        "x-scheme-handler/https" = config.ar.home.defaultApps.webBrowser.desktop;
      };
    };
    home.sessionVariables = {
      BROWSER = "${config.ar.home.defaultApps.webBrowser.exe}";
      EDITOR = "${config.ar.home.defaultApps.terminalEditor.exe}";
      TERMINAL = "${config.ar.home.defaultApps.terminal.exe}";
    };
  };
}
