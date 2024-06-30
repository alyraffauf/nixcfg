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

        defaultApplications = let
          audioTypes =
            lib.genAttrs [
              "application/mpeg4-iod"
              "application/mpeg4-muxcodetable"
              "application/mxf"
              "application/ogg"
              "application/vnd.apple.mpegurl"
              "application/vnd.ms-asf"
              "application/vnd.rn-realmedia-vbr"
              "application/vnd.rn-realmedia"
              "application/x-extension-m4a"
              "application/x-flac"
              "application/x-ogg"
              "application/x-streamingmedia"
              "audio/3gpp"
              "audio/3gpp2"
              "audio/aac"
              "audio/ac3"
              "audio/amr-wb"
              "audio/amr"
              "audio/basic"
              "audio/dv"
              "audio/eac3"
              "audio/flac"
              "audio/m4a"
              "audio/midi"
              "audio/mp1"
              "audio/mp2"
              "audio/mp3"
              "audio/mp4"
              "audio/mpeg"
              "audio/mpegurl"
              "audio/mpg"
              "audio/ogg"
              "audio/opus"
              "audio/scpls"
              "audio/vnd.dolby.heaac.1"
              "audio/vnd.dolby.heaac.2"
              "audio/vnd.dolby.mlp"
              "audio/vnd.dts.hd"
              "audio/vnd.dts"
              "audio/vnd.rn-realaudio"
              "audio/wav"
              "audio/webm"
              "audio/x-aac"
              "audio/x-aiff"
              "audio/x-ape"
              "audio/x-flac"
              "audio/x-gsm"
              "audio/x-it"
              "audio/x-m4a"
              "audio/x-matroska"
              "audio/x-mod"
              "audio/x-mp1"
              "audio/x-mp2"
              "audio/x-mp3"
              "audio/x-mpeg"
              "audio/x-mpegurl"
              "audio/x-mpg"
              "audio/x-ms-asf"
              "audio/x-ms-wma"
              "audio/x-musepack"
              "audio/x-opus+ogg"
              "audio/x-pn-aiff"
              "audio/x-pn-au"
              "audio/x-pn-realaudio"
              "audio/x-pn-wav"
              "audio/x-real-audio"
              "audio/x-realaudio"
              "audio/x-s3m"
              "audio/x-scpls"
              "audio/x-shorten"
              "audio/x-speex"
              "audio/x-tta"
              "audio/x-vorbis"
              "audio/x-vorbis+ogg"
              "audio/x-wav"
              "audio/x-wavpack"
              "audio/x-xm"
              "x-content/audio-cdda"
              "x-content/audio-player"
            ]
            (_: ["defaultAudioPlayer.desktop"]);

          browserTypes =
            lib.genAttrs [
              "application/vnd.mozilla.xul+xml"
              "application/x-extension-htm"
              "application/x-extension-html"
              "application/x-extension-shtml"
              "application/x-extension-xht"
              "application/x-extension-xhtml"
              "application/xhtml+xml"
              "text/html"
              "text/xml"
              "x-scheme-handler/chrome"
              "x-scheme-handler/ftp"
              "x-scheme-handler/http"
              "x-scheme-handler/http"
              "x-scheme-handler/https"
            ]
            (_: ["defaultWebBrowser.desktop"]);

          documentTypes =
            lib.genAttrs [
              "application/illustrator"
              "application/oxps"
              "application/pdf"
              "application/postscript"
              "application/vnd.comicbook-rar"
              "application/vnd.comicbook+zip"
              "application/vnd.ms-xpsdocument"
              "application/x-bzdvi"
              "application/x-bzpdf"
              "application/x-bzpostscript"
              "application/x-cb7"
              "application/x-cbr"
              "application/x-cbt"
              "application/x-cbz"
              "application/x-dvi"
              "application/x-ext-cb7"
              "application/x-ext-cbr"
              "application/x-ext-cbt"
              "application/x-ext-cbz"
              "application/x-ext-djv"
              "application/x-ext-djvu"
              "application/x-ext-dvi"
              "application/x-ext-eps"
              "application/x-ext-pdf"
              "application/x-ext-ps"
              "application/x-gzdvi"
              "application/x-gzpdf"
              "application/x-gzpostscript"
              "application/x-xzpdf"
              "image/tiff"
              "image/vnd.djvu"
              "image/x-bzeps"
              "image/x-eps"
              "image/x-gzeps"
            ]
            (_: ["defaultPdfViewer.desktop"]);

          editorTypes =
            lib.genAttrs [
              "application/json"
              "application/x-shellscript"
              "application/x-shellscript"
              "text/markdown"
              "text/plain"
              "text/x-python"
            ]
            (_: ["defaultEditor.desktop"]);

          folderTypes = {"inode/directory" = "defaultFIleManager.desktop";};

          imageTypes =
            lib.genAttrs [
              "image/bmp"
              "image/gif"
              "image/jpeg"
              "image/jpg"
              "image/pjpeg"
              "image/png"
              "image/svg+xml-compressed"
              "image/svg+xml"
              "image/tiff"
              "image/vnd.wap.wbmp"
              "image/webp"
              "image/x-bmp"
              "image/x-gray"
              "image/x-icb"
              "image/x-icns"
              "image/x-ico"
              "image/x-pcx"
              "image/x-png"
              "image/x-portable-anymap"
              "image/x-portable-bitmap"
              "image/x-portable-graymap"
              "image/x-portable-pixmap"
              "image/x-xbitmap"
              "image/x-xpixmap"
            ]
            (_: ["defaultImageViewer.desktop"]);

          videoTypes =
            lib.genAttrs [
              "application/mpeg4-iod"
              "application/mpeg4-muxcodetable"
              "application/vnd.apple.mpegurl"
              "application/x-extension-m4a"
              "application/x-extension-mp4"
              "application/x-flash-video"
              "application/x-matroska"
              "video/3gp"
              "video/3gpp"
              "video/3gpp2"
              "video/divx"
              "video/dv"
              "video/fli"
              "video/flv"
              "video/mp2t"
              "video/mp4"
              "video/mp4v-es"
              "video/mpeg-system"
              "video/mpeg"
              "video/msvideo"
              "video/ogg"
              "video/quicktime"
              "video/vnd.mpegurl"
              "video/vnd.rn-realvideo"
              "video/webm"
              "video/x-avi"
              "video/x-flc"
              "video/x-fli"
              "video/x-flv"
              "video/x-m4v"
              "video/x-matroska"
              "video/x-mpeg-system"
              "video/x-mpeg"
              "video/x-mpeg2"
              "video/x-ms-asf"
              "video/x-ms-wm"
              "video/x-ms-wmv"
              "video/x-ms-wmx"
              "video/x-msvideo"
              "video/x-nsv"
              "video/x-ogm+ogg"
              "video/x-theora"
              "video/x-theora+ogg"
              "x-content/video-dvd"
            ]
            (_: ["defaultVideoPlayer.desktop"]);
        in
          audioTypes
          // browserTypes
          // documentTypes
          // editorTypes
          // folderTypes
          // imageTypes
          // videoTypes;
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
