{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.thunderbird.enable = lib.mkEnableOption "thunderbird mail client";

  config = lib.mkIf config.myHome.aly.programs.thunderbird.enable {
    programs.thunderbird = {
      enable = true;
      package = lib.mkIf pkgs.stdenv.isDarwin (pkgs.runCommand "thunderbird-0.0.0" {} "mkdir $out");

      profiles.default = {
        isDefault = true;

        settings = {
          "calendar.timezone.useSystemTimezone" = true;
          "datareporting.healthreport.uploadEnabled" = false;
          "mail.tabs.drawInTitlebar" = true;
          "mailnews.default_sort_order" = 2; # descending, 1 for ascending
          "mailnews.default_sort_type" = 18; # sort by date
          "mailnews.message_display.disable_remote_image" = false;
          "mailnews.start_page.enabled" = false;
          "network.cookie.cookieBehavior" = 1;
          "pdfjs.enabledCache.state" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.firstparty.isolate" = true;
          "privacy.purge_trackers.date_in_cookie_database" = "0";
          "privacy.resistFingerprinting" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "toolkit.telemetry.enabled" = false;
        };
      };
    };
  };
}
