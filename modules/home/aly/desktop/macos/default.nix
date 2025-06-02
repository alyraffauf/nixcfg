{
  config,
  lib,
  ...
}: {
  options.myHome.aly.desktop.macos.enable = lib.mkEnableOption "macOS desktop configuration.";

  config = lib.mkIf config.myHome.aly.desktop.macos.enable {
    targets.darwin = {
      defaults = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.dock" = {
          autohide = false; # don't autohide dock
          expose-group-apps = true;
          minimize-to-application = true;
          mru-spaces = false; # do not rearrange spaces based on most recent use
          orientation = "left"; # left side of the screen
          scroll-to-open = true; # scroll over app to expose
          show-recents = false; # do not show recently closed apps
          size-immutable = true;
          tilesize = 64;
          workspaces-wrap-arrows = false;

          # # set hot corners
          wvous-tl-corner = 2;
          wvous-tr-corner = 12;
          wvous-bl-corner = 11;
          wvous-br-corner = 14;

          # persistent-apps = [];
          # # persistent-others = ["~/Desktop" "~/Downloads"];
        };

        "com.apple.finder" = {
          _FXSortFoldersFirstOnDesktop = true;
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true; # show hidden files
          CreateDesktop = false; # do not show icons on desktop
          FXDefaultSearchScope = "SCcf"; # search current folder by default
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          FXRemoveOldTrashItems = true;
          NewWindowTarget = "Home";
          QuitMenuItem = true;
          ShowPathbar = true;
          ShowStatusBar = true; # show status bar
        };

        "com.apple.Siri" = {
          ConfirmSiriInvokedViaEitherCmdTwice = 0;
          ContinuousSpellCheckingEnabled = 0;
          GrammarCheckingEnabled = 1;
          StatusMenuVisible = 0;
          VoiceTriggerUserEnabled = 1;
        };

        NSGlobalDomain = {
          NSAutomaticSpellingCorrectionEnabled = false;
          NSDocumentSaveNewDocumentsToCloud = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSQuitAlwaysKeepsWindows = false;
          NSWindowShouldDragOnGesture = true;
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;
        };
      };

      search = "DuckDuckGo";
    };
  };
}
