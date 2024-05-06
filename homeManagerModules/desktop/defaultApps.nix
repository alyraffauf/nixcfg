{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.defaultApps.enable =
      lib.mkEnableOption "GTK and Qt themes.";
    alyraffauf.desktop.defaultApps.webBrowser = {
      exe = lib.mkOption {
        description = "Default web browser executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.webBrowser.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default web browser desktop file name.";
        default = "firefox.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default web browser package.";
        default = config.programs.firefox.package;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.editor = {
      exe = lib.mkOption {
        description = "Default editor executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.editor.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default editor desktop file name.";
        default = "codium.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default editor package.";
        default = config.programs.vscode.package;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.terminalEditor = {
      exe = lib.mkOption {
        description = "Default terminal editor executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.terminalEditor.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default terminal editor desktop file name.";
        default = "nvim.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default terminal editor package.";
        default = config.programs.neovim.package;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.terminal = {
      exe = lib.mkOption {
        description = "Default terminal executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.terminal.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default terminal desktop file name.";
        default = "alacritty.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default terminal package.";
        default = config.programs.alacritty.package;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.pdfEditor = {
      exe = lib.mkOption {
        description = "Default PDF editor executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.pdfEditor.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default PDF Editor desktop file name.";
        default = "org.gnome.Evince.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default PDF Editor package.";
        default = pkgs.evince;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.imageViewer = {
      exe = lib.mkOption {
        description = "Default image viewer executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.imageViewer.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default image viewer desktop file name.";
        default = "org.gnome.eog.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default image viewer package.";
        default = pkgs.gnome.eog;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.videoPlayer = {
      exe = lib.mkOption {
        description = "Default video player executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.videoPlayer.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default video player desktop file name.";
        default = "io.github.celluloid_player.Celluloid.desktop";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default video player package.";
        default = pkgs.celluloid;
        type = lib.types.package;
      };
    };
    alyraffauf.desktop.defaultApps.audioPlayer = {
      exe = lib.mkOption {
        description = "Default audio player executable name.";
        default = lib.getExe config.alyraffauf.desktop.defaultApps.audioPlayer.package;
        type = lib.types.str;
      };
      desktop = lib.mkOption {
        description = "Default audio player desktop file name.";
        default = config.alyraffauf.desktop.defaultApps.videoPlayer.desktop;
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Default audio player package.";
        default = config.alyraffauf.desktop.defaultApps.videoPlayer.package;
        type = lib.types.package;
      };
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.defaultApps.enable {
    home.packages = with pkgs; [
      config.alyraffauf.desktop.defaultApps.audioPlayer.package
      config.alyraffauf.desktop.defaultApps.editor.package
      config.alyraffauf.desktop.defaultApps.imageViewer.package
      config.alyraffauf.desktop.defaultApps.pdfEditor.package
      config.alyraffauf.desktop.defaultApps.terminalEditor.package
      config.alyraffauf.desktop.defaultApps.videoPlayer.package
      config.alyraffauf.desktop.defaultApps.webBrowser.package
    ];
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = config.alyraffauf.desktop.defaultApps.pdfEditor.desktop;
        "application/x-shellscript" = config.alyraffauf.desktop.defaultApps.editor.desktop;
        "application/xhtml+xml" = config.alyraffauf.desktop.defaultApps.webBrowser.desktop;
        "audio/flac" = config.alyraffauf.desktop.defaultApps.audioPlayer.desktop;
        "audio/mpeg" = config.alyraffauf.desktop.defaultApps.audioPlayer.desktop;
        "audio/opus" = config.alyraffauf.desktop.defaultApps.audioPlayer.desktop;
        "image/jpeg" = config.alyraffauf.desktop.defaultApps.imageViewer.desktop;
        "image/png" = config.alyraffauf.desktop.defaultApps.imageViewer.desktop;
        "text/html" = config.alyraffauf.desktop.defaultApps.webBrowser.desktop;
        "text/plain" = config.alyraffauf.desktop.defaultApps.editor.desktop;
        "text/x-python" = config.alyraffauf.desktop.defaultApps.editor.desktop;
        "text/xml" = config.alyraffauf.desktop.defaultApps.webBrowser.desktop;
        "video/H264" = config.alyraffauf.desktop.defaultApps.videoPlayer.desktop;
        "video/mp4" = config.alyraffauf.desktop.defaultApps.videoPlayer.desktop;
        "video/mpeg" = config.alyraffauf.desktop.defaultApps.videoPlayer.desktop;
        "video/ogg" = config.alyraffauf.desktop.defaultApps.videoPlayer.desktop;
        "video/x-matroska" = config.alyraffauf.desktop.defaultApps.videoPlayer.desktop;
        "x-scheme-handler/ftp" = config.alyraffauf.desktop.defaultApps.webBrowser.desktop;
        "x-scheme-handler/http" = config.alyraffauf.desktop.defaultApps.webBrowser.desktop;
        "x-scheme-handler/https" = config.alyraffauf.desktop.defaultApps.webBrowser.desktop;
      };
    };
    home.sessionVariables = {
      EDITOR = "${config.alyraffauf.desktop.defaultApps.terminalEditor.exe}";
      BROWSER = "${config.alyraffauf.desktop.defaultApps.webBrowser.exe}";
      TERMINAL = "${config.alyraffauf.desktop.defaultApps.terminal.exe}";
    };
  };
}
