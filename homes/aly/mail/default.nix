{
  config,
  lib,
  pkgs,
  ...
}: let
  mkPassword = secret: "${lib.getExe' pkgs.coreutils "cat"} ${secret}";
in {
  accounts.email.accounts = {
    "alyraffauf@fastmail.com" = {
      address = "alyraffauf@fastmail.com";
      aliases = ["aly@raffauflabs.com"];
      flavor = "fastmail.com";
      himalaya.enable = true;
      passwordCommand = mkPassword config.age.secrets.alyraffaufFastmail.path;
      primary = true;
      realName = "Aly Raffauf";

      signature = {
        text = ''
          Thank you,
          Aly Raffauf
          https://aly.raffauflabs.com
        '';

        showSignature = "append";
      };

      thunderbird = {
        enable = true;
        profiles = ["default"];
      };

      userName = "alyraffauf@fastmail.com";
    };

    "achacega@gmail.com" = {
      address = "achacega@gmail.com";
      aliases = ["alyraffauf@gmail.com"];
      flavor = "gmail.com";
      himalaya.enable = true;
      passwordCommand = mkPassword config.age.secrets.achacegaGmail.path;
      realName = "Aly Raffauf";

      signature = {
        text = ''
          --
          Aly Raffauf (née Chace)
        '';

        showSignature = "append";
      };

      thunderbird = {
        enable = true;
        profiles = ["default"];
      };

      userName = "achacega@gmail.com";
    };
  };

  programs = {
    himalaya.enable = true;

    thunderbird = {
      enable = true;

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
          "network.cookie.cookieBehavior" = 2; # no cookies
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
