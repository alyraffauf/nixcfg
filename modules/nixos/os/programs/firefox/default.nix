{
  config,
  lib,
  ...
}: {
  options.myNixOS.programs.firefox.enable = lib.mkEnableOption "firefox browser";

  config = lib.mkIf config.myNixOS.programs.firefox.enable {
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
          # Do not add the extra "Import Bookmarks" button in the bookmarks interface
          "browser.bookmarks.addedImportButton" = false;

          # Mark that the user has accepted the data reporting (telemetry) policy
          "datareporting.policy.dataSubmissionPolicyAccepted" = true;

          # Allow extensions from all scopes (profile, system, etc.) without auto-disabling them
          "extensions.autoDisableScopes" = 0;

          # Enable VA-API hardware video decoding via FFmpeg (useful on Linux systems)
          "media.ffmpeg.vaapi.enabled" = true;

          # Enable the VP8/VP9 media data decoder, used in WebRTC and video playback
          "media.navigator.mediadatadecoder_vpx_enabled" = true;

          # Enable the Remote Data Decoder (RDD) process for FFmpeg to isolate media decoding tasks
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
