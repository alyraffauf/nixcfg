{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.defaultApps;
  mimeTypes = import ./mimeTypes.nix;
in {
  options.myHome.defaultApps = {
    enable = lib.mkEnableOption "Declaratively set default apps and file associations.";
    forceMimeAssociations = lib.mkEnableOption "Force mime associations for defaultApps.";

    audioPlayer = lib.mkPackageOption pkgs "audio player" {default = ["celluloid"];};
    editor = lib.mkPackageOption pkgs "text editor" {default = ["vscodium"];};
    fileManager = lib.mkPackageOption pkgs "file manager" {default = ["nemo"];};
    imageViewer = lib.mkPackageOption pkgs "image viewer" {default = ["eog"];};
    pdfViewer = lib.mkPackageOption pkgs "pdf viewer" {default = ["evince"];};
    terminal = lib.mkPackageOption pkgs "terminal emulator" {default = ["wezterm"];};
    terminalEditor = lib.mkPackageOption pkgs "terminal text editor" {default = ["vim"];};
    videoPlayer = lib.mkPackageOption pkgs "video player" {default = ["celluloid"];};

    webBrowser = lib.mkOption {
      description = "web browser";
      default = config.programs.firefox.finalPackage;
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "${lib.getExe cfg.terminal}";
        "org/cinnamon/desktop/default-applications/terminal".exec = "${lib.getExe cfg.terminal}";
      };
    };

    home = {
      packages = with cfg; [
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
        BROWSER = "${builtins.baseNameOf (lib.getExe cfg.webBrowser)}";
        EDITOR = "${builtins.baseNameOf (lib.getExe cfg.terminalEditor)}";
        TERMINAL = "${builtins.baseNameOf (lib.getExe cfg.terminal)}";
      };
    };

    xdg = {
      configFile."xfce4/helpers.rc".text = ''
        FileManager=${builtins.baseNameOf (lib.getExe cfg.fileManager)}
        TerminalEmulator=${builtins.baseNameOf (lib.getExe cfg.terminal)}
        WebBrowser=${builtins.baseNameOf (lib.getExe cfg.webBrowser)}
      '';

      mimeApps = lib.mkIf cfg.forceMimeAssociations {
        enable = true;

        defaultApplications = let
          mkDefaults = files: desktopFile: lib.genAttrs files (_: [desktopFile]);
          audioTypes =
            mkDefaults mimeTypes.audioFiles
            "defaultAudioPlayer.desktop";

          browserTypes =
            mkDefaults mimeTypes.browserFiles
            "defaultWebBrowser.desktop";

          documentTypes =
            mkDefaults mimeTypes.documentFiles
            "defaultPdfViewer.desktop";

          editorTypes =
            mkDefaults mimeTypes.editorFiles
            "defaultEditor.desktop";

          folderTypes = {"inode/directory" = "defaultFileManager.desktop";};

          imageTypes =
            mkDefaults mimeTypes.imageFiles
            "defaultImageViewer.desktop";

          videoTypes =
            mkDefaults mimeTypes.videoFiles
            "defaultVideoPlayer.desktop";
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
          exec = "${lib.getExe package} %U";
          icon = "${builtins.baseNameOf (lib.getExe package)}";
          name = "Default ${name}";
          terminal = false;

          settings = {
            NoDisplay = "true";
          };
        };
      in
        lib.mkIf cfg.forceMimeAssociations {
          defaultAudioPlayer = mkDefaultEntry "Audio Player" cfg.audioPlayer;
          defaultEditor = mkDefaultEntry "Editor" cfg.editor;
          defaultFileManager = mkDefaultEntry "File Manager" cfg.fileManager;
          defaultImageViewer = mkDefaultEntry "Image Viewer" cfg.imageViewer;
          defaultPdfViewer = mkDefaultEntry "PDF Viewer" cfg.pdfViewer;
          defaultVideoPlayer = mkDefaultEntry "Video Player" cfg.videoPlayer;
          defaultWebBrowser = mkDefaultEntry "Web Browser" cfg.webBrowser;
        };
    };
  };
}
