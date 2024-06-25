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
        "org/cinnamon/desktop/applications/terminal".exec = "${config.alyraffauf.defaultApps.terminal.exe}";
        "org/cinnamon/desktop/default-applications/terminal".exec = "${config.alyraffauf.defaultApps.terminal.exe}";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = config.alyraffauf.defaultApps.editor.desktop;
        "application/pdf" = config.alyraffauf.defaultApps.pdfViewer.desktop;
        "application/x-extension-htm" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "application/x-extension-html" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "application/x-extension-shtml" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "application/x-extension-xht" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "application/x-extension-xhtml" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "application/x-shellscript" = config.alyraffauf.defaultApps.editor.desktop;
        "application/xhtml+xml" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "audio/*" = config.alyraffauf.defaultApps.audioPlayer.desktop;
        "image/*" = config.alyraffauf.defaultApps.imageViewer.desktop;
        "inode/directory" = config.alyraffauf.defaultApps.fileManager.desktop;
        "text/html" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "text/markdown" = config.alyraffauf.defaultApps.editor.desktop;
        "text/plain" = config.alyraffauf.defaultApps.editor.desktop;
        "text/x-python" = config.alyraffauf.defaultApps.editor.desktop;
        "text/xml" = config.alyraffauf.defaultApps.webBrowser.desktop;
        "video/*" = config.alyraffauf.defaultApps.videoPlayer.desktop;
        "x-scheme-handler/chrome" = config.alyraffauf.defaultApps.webBrowser.desktop;
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
