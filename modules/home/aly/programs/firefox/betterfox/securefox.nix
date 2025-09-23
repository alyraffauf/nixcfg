{
  # SECUREFOX
  "browser.contentblocking.category" = "strict";
  "privacy.trackingprotection.allow_list.baseline.enabled" = true;
  "privacy.trackingprotection.allow_list.convenience.enabled" = true;
  "browser.download.start_downloads_in_tmp_dir" = true;
  "browser.helperApps.deleteTempFileOnExit" = true;
  "browser.uitour.enabled" = false;
  "privacy.globalprivacycontrol.enabled" = true;

  "security.OCSP.enabled" = 0;
  "security.pki.crlite_mode" = 2;
  "security.csp.reporting.enabled" = false;

  "security.ssl.treat_unsafe_negotiation_as_broken" = true;
  "browser.xul.error_pages.expert_bad_cert" = true;
  "security.tls.enable_0rtt_data" = false;

  "browser.privatebrowsing.forceMediaMemoryCache" = true;
  "browser.sessionstore.interval" = 60000;

  "browser.privatebrowsing.resetPBM.enabled" = true;
  "privacy.history.custom" = true;

  "browser.urlbar.trimHttps" = true;
  "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
  "browser.search.separatePrivateDefault.ui.enabled" = true;
  "browser.search.suggest.enabled" = false;
  "browser.urlbar.quicksuggest.enabled" = false;
  "browser.urlbar.groupLabels.enabled" = false;
  "browser.formfill.enable" = false;
  "network.IDN_show_punycode" = true;

  "signon.formlessCapture.enabled" = false;
  "signon.privateBrowsingCapture.enabled" = false;
  "network.auth.subresource-http-auth-allow" = 1;
  "editor.truncate_user_pastes" = false;

  "security.mixed_content.block_display_content" = true;
  "pdfjs.enableScripting" = false;

  "extensions.enabledScopes" = 5;

  "network.http.referer.XOriginTrimmingPolicy" = 2;

  "privacy.userContext.ui.enabled" = true;

  "browser.safebrowsing.downloads.remote.enabled" = false;

  "permissions.default.desktop-notification" = 2;
  "permissions.default.geo" = 2;
  "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
  "browser.search.update" = false;
  "permissions.manager.defaultsUrl" = "";
  "extensions.getAddons.cache.enabled" = false;

  "datareporting.policy.dataSubmissionEnabled" = false;
  "datareporting.healthreport.uploadEnabled" = false;
  "toolkit.telemetry.unified" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.server" = "data:,";
  "toolkit.telemetry.archive.enabled" = false;
  "toolkit.telemetry.newProfilePing.enabled" = false;
  "toolkit.telemetry.shutdownPingSender.enabled" = false;
  "toolkit.telemetry.updatePing.enabled" = false;
  "toolkit.telemetry.bhrPing.enabled" = false;
  "toolkit.telemetry.firstShutdownPing.enabled" = false;
  "toolkit.telemetry.coverage.opt-out" = true;
  "toolkit.coverage.opt-out" = true;
  "toolkit.coverage.endpoint.base" = "";
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;
  "datareporting.usage.uploadEnabled" = false;

  "app.shield.optoutstudies.enabled" = false;
  "app.normandy.enabled" = false;
  "app.normandy.api_url" = "";

  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = false;
}
