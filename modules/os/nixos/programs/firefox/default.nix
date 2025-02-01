{lib, ...}: {
  config = {
    home-manager.sharedModules = [
      {
        myHome.apps.firefox.enable = lib.mkDefault true;
      }
    ];

    programs.firefox = {
      enable = true;

      policies = {
        Cookies.Behavior = "reject-foreign";
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisableMasterPasswordCreation = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "newtab";

        DNSOverHTTPS = {
          Enabled = true;
          Fallback = true;
        };

        DontCheckDefaultBrowser = true;

        EnableTrackingProtection = {
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
          Locked = false;
          Value = true;
        };

        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = false;
        };

        FirefoxHome = {
          Highlights = false;
          Locked = false;
          Pocket = false;
          Search = true;
          Snippets = false;
          SponsoredPocket = false;
          SponsoredTopSites = false;
          TopSites = false;
        };

        FirefoxSuggest = {
          ImproveSuggest = false;
          Locked = false;
          SponsoredSuggestions = false;
          WebSuggestions = false;
        };

        HardwareAcceleration = true;

        Homepage = {
          Locked = false;
          StartPage = "previous-session";
        };

        NewTabPage = false;
        NoDefaultBookmarks = false; # Enabling this prevents declaratively setting bookmarks.
        OfferToSaveLoginsDefault = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";

        PDFjs = {
          Enabled = true;
          EnablePermissions = false;
        };

        Preferences = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.addedImportButton" = false;
          "datareporting.policy.dataSubmissionPolicyAccepted" = true;
          "dom.security.https_only_mode" = true;
          "extensions.autoDisableScopes" = 0;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.navigator.mediadatadecoder_vpx_enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };

        UseSystemPrintDialog = true;
      };
    };
  };
}
