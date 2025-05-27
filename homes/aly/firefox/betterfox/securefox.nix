{
  # ****************************************************************************
  # Securefox
  # "Natura non contristatur"
  # priority: provide sensible security and privacy
  # version: 137
  # url: https://github.com/yokoffing/Betterfox
  # credit: Most prefs are reproduced and adapted from the arkenfox project
  # credit urL: https://github.com/arkenfox/user.js
  # ****************************************************************************

  #############################################################
  # SECTION: TRACKING PROTECTION
  #############################################################

  ## Enhanced Tracking Protection (ETP)
  "browser.contentblocking.category" = "strict"; # [HIDDEN]
  # "privacy.trackingprotection.enabled" = true;            # enabled with "Strict"
  # "privacy.trackingprotection.pbmode.enabled" = true;     # DEFAULT
  # "browser.contentblocking.customBlockList.preferences.ui.enabled" = false;  # DEFAULT
  # "privacy.trackingprotection.socialtracking.enabled" = true;  # enabled with "Strict"
  #   "privacy.socialtracking.block_cookies.enabled" = true;  # DEFAULT
  # "privacy.trackingprotection.cryptomining.enabled" = true;  # DEFAULT
  # "privacy.trackingprotection.fingerprinting.enabled" = true;  # DEFAULT
  # "privacy.trackingprotection.emailtracking.enabled" = true;  # enabled with "Strict"
  # "network.http.referer.disallowCrossSiteRelaxingDefault" = true;  # DEFAULT
  #   "network.http.referer.disallowCrossSiteRelaxingDefault.pbmode" = true;  # DEFAULT
  #   "network.http.referer.disallowCrossSiteRelaxingDefault.pbmode.top_navigation" = true;  # DEFAULT
  #   "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;  # enabled with "Strict"
  # "privacy.annotate_channels.strict_list.enabled" = true;  # enabled with "Strict"
  #   "privacy.annotate_channels.strict_list.pbmode.enabled" = true;  # DEFAULT
  # "privacy.fingerprintingProtection" = true;  # [FF114+] [ETP FF119+] enabled with "Strict"
  #   "privacy.fingerprintingProtection.pbmode" = true;  # DEFAULT
  # "privacy.bounceTrackingProtection.mode" = 1;  # [FF131+] [ETP FF133+]

  ## Query Stripping
  # "privacy.query_stripping.enabled" = true;         # enabled with "Strict"
  # "privacy.query_stripping.enabled.pbmode" = true;  # enabled with "Strict"
  # "privacy.query_stripping.strip_list" = "";        # DEFAULT
  # "privacy.query_stripping.strip_on_share.enabled" = true;

  ## Smartblock
  # "extensions.webcompat.enable_shims" = true;       # [HIDDEN] enabled with "Strict"
  # "extensions.webcompat.smartblockEmbeds.enabled" = true;  # enabled with "Strict"

  ## Embedded Social Content
  # "urlclassifier.trackingSkipURLs" = "embed.reddit.com, *.twitter.com, *.twimg.com";  # MANUAL [FF136+]
  # "urlclassifier.features.socialtracking.skipURLs" = "*.twitter.com, *.twimg.com";    # MANUAL [FF136+]
  # "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";  # MANUAL
  # "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";  # MANUAL

  ## Lower Network Priority for Trackers
  # "privacy.trackingprotection.lower_network_priority" = true;

  ## Site Isolation (Fission)
  # "fission.autostart" = true;                       # DEFAULT [DO NOT TOUCH]
  # "fission.webContentIsolationStrategy" = 1;         # DEFAULT

  ## GPU Sandboxing [WINDOWS]
  # "security.sandbox.gpu.level" = 1;                  # DEFAULT WINDOWS

  ## State Partitioning & Cookie Behavior
  # "network.cookie.cookieBehavior" = 5;               # DEFAULT FF103+
  # "network.cookie.cookieBehavior.optInPartitioning" = true;  # [ETP FF132+]
  # "browser.contentblocking.reject-and-isolate-cookies.preferences.ui.enabled" = true;  # DEFAULT

  ## Network Partitioning
  # "privacy.partition.network_state" = true;           # DEFAULT
  #   "privacy.partition.serviceWorkers" = true;        # DEFAULT: true FF105+
  #   "privacy.partition.network_state.ocsp_cache" = true;  # DEFAULT: true FF123+
  #   "privacy.partition.bloburl_per_partition_key" = true;  # FF118+
  # "privacy.partition.always_partition_third_party_non_cookie_storage" = true;    # DEFAULT: true FF109+
  # "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;  # DEFAULT: false FF109+

  ## Redirect Tracking Prevention
  # "privacy.purge_trackers.enabled" = true;            # DEFAULT

  ## SameSite Cookies
  # "network.cookie.sameSite.laxByDefault" = true;
  # "network.cookie.sameSite.noneRequiresSecure" = true;      # DEFAULT FF131+
  # "network.cookie.sameSite.schemeful" = true;

  ## Hyperlink Auditing
  # "browser.send_pings" = false;                     # DEFAULT

  ## Beacon API
  # "beacon.enabled" = false;

  ## Battery Status API
  # "dom.battery.enabled" = false;

  ## Temporary-File Handling
  "browser.download.start_downloads_in_tmp_dir" = true; # [FF102+]
  "browser.helperApps.deleteTempFileOnExit" = true;

  ## UITour
  "browser.uitour.enabled" = false;
  # "browser.uitour.url" = "";

  ## Remote Debugging
  # "devtools.debugger.remote-enabled" = false;       # DEFAULT

  ## Global Privacy Control (GPC)
  "privacy.globalprivacycontrol.enabled" = true;
  # "privacy.globalprivacycontrol.functionality.enabled" = true;  # [FF120+]
  # "privacy.globalprivacycontrol.pbmode.enabled" = true;         # [FF120+]

  #############################################################
  # SECTION: OSCP & CERTS / HPKP
  #############################################################

  ## OCSP
  "security.OCSP.enabled" = 0;
  # "security.OCSP.require" = true;

  ## CRLite
  # "security.remote_settings.crlite_filters.enabled" = true;  # DEFAULT: true FF137+
  "security.pki.crlite_mode" = 2;

  ## HPKP
  # "security.cert_pinning.enforcement_level" = 2;

  ## Enterprise Roots
  # "security.enterprise_roots.enabled" = false;
  #   "security.certerrors.mitm.auto_enable_enterprise_roots" = false;

  ## DLP Content Analysis
  # "browser.contentanalysis.enabled" = false;  # [FF121+] [DEFAULT]
  # "browser.contentanalysis.default_result" = 0;  # [FF127+] [DEFAULT]

  #############################################################
  # SECTION: SSL / TLS
  #############################################################

  "security.ssl.treat_unsafe_negotiation_as_broken" = true;
  # "security.ssl.require_safe_negotiation" = true;

  "browser.xul.error_pages.expert_bad_cert" = true;
  "security.tls.enable_0rtt_data" = false;
  # "security.tls.enable_kyber" = true;
  # "network.http.http3.enable_kyber" = true;

  #############################################################
  # SECTION: FINGERPRINT PROTECTION (FPP)
  #############################################################

  # "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
  # "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;

  #############################################################
  # SECTION: RESIST FINGERPRINTING (RFP)
  #############################################################

  # "privacy.resistFingerprinting" = true;
  # "privacy.window.maxInnerWidth" = 1600;
  # "privacy.window.maxInnerHeight" = 900;
  # "browser.startup.blankWindow" = false;
  # "browser.display.use_system_colors" = false;

  #############################################################
  # SECTION: DISK AVOIDANCE
  #############################################################

  "browser.privatebrowsing.forceMediaMemoryCache" = true;
  "browser.sessionstore.interval" = 60000; # 1 min; default=15000

  # "browser.sessionstore.privacy_level" = 2;
  # "toolkit.winRegisterApplicationRestart" = false;
  # "browser.shell.shortcutFavicons" = false;
  # "browser.helperApps.deleteTempFileOnExit" = true;
  # "browser.pagethumbnails.capturing_disabled" = true;

  #############################################################
  # SECTION: SANITIZE HISTORY
  #############################################################

  # "privacy.sanitize.timeSpan" = 0;
  # "privacy.clearSiteData.cache" = true;
  # "privacy.clearSiteData.cookiesAndStorage" = false;
  # "privacy.clearSiteData.historyFormDataAndDownloads" = true;
  "browser.privatebrowsing.resetPBM.enabled" = true;

  #############################################################
  # SECTION: SHUTDOWN & SANITIZING
  #############################################################

  "privacy.history.custom" = true;
  # "privacy.sanitize.sanitizeOnShutdown" = true;
  # "privacy.clearOnShutdown.cache" = true;
  # "privacy.clearOnShutdown_v2.cache" = true;
  # "privacy.clearOnShutdown.downloads" = true;
  # "privacy.clearOnShutdown.formdata" = true;
  # "privacy.clearOnShutdown.history" = true;
  # "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
  # "privacy.clearOnShutdown.siteSettings" = false;
  # "privacy.clearOnShutdown_v2.siteSettings" = false;
  # "privacy.clearOnShutdown.cookies" = true;
  # "privacy.clearOnShutdown.offlineApps" = true;
  # "privacy.clearOnShutdown.sessions" = true;
  # "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
  # "privacy.clearOnShutdown.openWindows" = true;

  #############################################################
  # SECTION: SEARCH / URL BAR
  #############################################################

  # "browser.urlbar.trimURLs" = true;
  "browser.urlbar.trimHttps" = true;
  "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
  # "security.insecure_connection_text.enabled" = true;
  # "security.insecure_connection_text.pbmode.enabled" = true;

  "browser.search.separatePrivateDefault.ui.enabled" = true;
  # "browser.search.separatePrivateDefault" = true;

  "browser.urlbar.update2.engineAliasRefresh" = true;
  "browser.search.suggest.enabled" = false;
  # "browser.search.suggest.enabled.private" = false;

  "browser.urlbar.quicksuggest.enabled" = false;
  # "browser.urlbar.suggest.quicksuggest.sponsored" = false;
  # "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

  "browser.urlbar.groupLabels.enabled" = false;
  "browser.formfill.enable" = false;

  # "browser.fixup.alternate.enabled" = false;
  # "browser.urlbar.autoFill" = false;
  "network.IDN_show_punycode" = true;

  #############################################################
  # SECTION: HTTPS-FIRST POLICY
  #############################################################

  # "dom.security.https_first" = true;
  # "dom.security.https_first_pbm" = true;
  # "dom.security.https_first_schemeless" = true;

  #############################################################
  # SECTION: HTTPS-ONLY MODE
  #############################################################

  # "dom.security.https_only_mode_pbm" = true;
  # "dom.security.https_only_mode" = true;
  # "dom.security.https_only_mode_error_page_user_suggestions" = true;
  # "dom.security.https_only_mode_send_http_background_request" = true;
  #   "dom.security.https_only_fire_http_request_background_timer_ms" = 3000;
  # "dom.security.https_only_mode.upgrade_local" = false;

  #############################################################
  # SECTION: DNS-over-HTTPS
  #############################################################

  # "network.trr.mode" = 0;
  # "network.trr.max-fails" = 5;
  # "network.trr_ui.show_fallback_warning_option" = false;
  # "network.trr.display_fallback_warning" = false;
  # "network.trr.uri" = "https://xxxx/dns-query";
  #   "network.trr.custom_uri" = "https://xxxx/dns-query";
  # "network.trr.bootstrapAddr" = "10.0.0.1";
  # "network.trr.resolvers" = '[{"name":"Cloudflare","url":"https://mozilla.cloudflare-dns.com/dns-query"}, …]';
  # "network.trr.disable-ECS" = true;
  # "network.trr.allow-rfc1918" = false;
  # "network.trr.confirmationNS" = "skip";
  # "network.trr.skip-AAAA-when-not-supported" = true;
  # "network.trr.clear-cache-on-pref-change" = true;
  # "network.trr.wait-for-portal" = false;
  # "network.trr.excluded-domains" = "";
  # "network.trr.builtin-excluded-domains" = "localhost,local";
  # "network.trr.ohttp.config_uri" = "https://dooh.cloudflare-dns.com/.well-known/doohconfig";
  # "network.trr.ohttp.uri" = "https://dooh.cloudflare-dns.com/dns-query";
  # "network.trr.ohttp.relay_uri" = "";
  # "network.trr.use_ohttp" = true;
  # "network.dns.echconfig.enabled" = true;
  # "network.dns.http3_echconfig.enabled" = true;
  # "network.dns.echconfig.fallback_to_origin_when_all_failed" = false;

  #############################################################
  # SECTION: PROXY / SOCKS / IPv6
  #############################################################

  # "network.dns.disableIPv6" = true;
  # "network.proxy.socks_remote_dns" = true;
  # "network.file.disable_unc_paths" = true;
  # "network.gio.supported-protocols" = "";
  # "network.notify.checkForProxies" = false;

  #############################################################
  # SECTION: PASSWORDS
  #############################################################

  # "signon.rememberSignons" = false;
  #   "signon.schemeUpgrades" = true;
  #   "signon.showAutoCompleteFooter" = true;
  #   "signon.autologin.proxy" = false;

  # "signon.autofillForms" = false;
  # "signon.autofillForms.autocompleteOff" = true;
  "signon.formlessCapture.enabled" = false;
  "signon.privateBrowsingCapture.enabled" = false;
  # "signon.autofillForms.http" = false;
  # "signon.generation.enabled" = false;
  #   "signon.management.page.breach-alerts.enabled" = false;
  #   "signon.management.page.breachAlertUrl" = "";
  # "browser.contentblocking.report.lockwise.enabled" = false;
  # "signon.firefoxRelay.feature" = "";
  # "signon.storeWhenAutocompleteOff" = false;
  "network.auth.subresource-http-auth-allow" = 1;
  "editor.truncate_user_pastes" = false;
  # "layout.forms.reveal-password-context-menu.enabled" = true;
  # "layout.forms.reveal-password-button.enabled" = true;

  #############################################################
  # SECTION: ADDRESS + CREDIT CARD MANAGER
  #############################################################

  # "extensions.formautofill.addresses.enabled" = false;
  # "extensions.formautofill.creditCards.enabled" = false;

  #############################################################
  # SECTION: MIXED CONTENT + CROSS-SITE
  #############################################################

  "security.mixed_content.block_display_content" = true;
  "pdfjs.enableScripting" = false;
  # "browser.tabs.searchclipboardfor.middleclick" = false;
  # "network.http.windows-sso.enabled" = false;

  #############################################################
  # SECTION: EXTENSIONS
  #############################################################

  "extensions.enabledScopes" = 5;
  # "extensions.autoDisableScopes" = 15;
  # "extensions.postDownloadThirdPartyPrompt" = false;
  # "privacy.resistFingerprinting.block_mozAddonManager" = true;
  # "extensions.webextensions.restrictedDomains" = "";
  # "xpinstall.signatures.required" = false;
  # "extensions.quarantinedDomains.enabled" = false;

  #############################################################
  # SECTION: HEADERS / REFERERS
  #############################################################

  # "network.http.referer.defaultPolicy" = 2;
  # "network.http.referer.defaultPolicy.pbmode" = 2;
  # "network.http.referer.defaultPolicy.trackers" = 1;
  # "network.http.referer.defaultPolicy.trackers.pbmode" = 1;
  # "network.http.sendRefererHeader" = 2;
  # "network.http.referer.XOriginPolicy" = 0;
  "network.http.referer.XOriginTrimmingPolicy" = 2;

  #############################################################
  # SECTION: CONTAINERS
  #############################################################

  "privacy.userContext.ui.enabled" = true;
  # "privacy.userContext.enabled" = true;
  # "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;
  # "browser.link.force_default_user_context_id_for_external_opens" = true;

  #############################################################
  # SECTION: WEBRTC
  #############################################################

  # "media.peerconnection.enabled" = false;
  # "privacy.webrtc.globalMuteToggles" = true;
  # "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
  # "media.peerconnection.ice.default_address_only" = true;
  # "media.peerconnection.ice.no_host" = true;

  #############################################################
  # SECTION: PLUGINS
  #############################################################

  # "media.gmp-provider.enabled" = false;
  # "media.gmp-widevinecdm.enabled" = false;
  # "media.eme.enabled" = false;
  #   "browser.eme.ui.enabled" = false;

  #############################################################
  # SECTION: VARIOUS
  #############################################################

  # "browser.urlbar.decodeURLsOnCopy" = false;
  # "devtools.selfxss.count" = 5;
  # "javascript.options.asmjs" = false;
  # "javascript.options.ion" = false;
  # "javascript.options.baselinejit" = false;
  # "javascript.options.jit_trustedprincipals" = true;
  # "javascript.options.wasm" = false;

  #############################################################
  # SECTION: SAFE BROWSING (SB)
  #############################################################

  # "browser.safebrowsing.malware.enabled" = false;
  # "browser.safebrowsing.phishing.enabled" = false;
  # "browser.safebrowsing.blockedURIs.enabled" = false;
  #   "browser.safebrowsing.provider.google4.gethashURL" = "";
  #   "browser.safebrowsing.provider.google4.updateURL" = "";
  #   "browser.safebrowsing.provider.google.gethashURL" = "";
  #   "browser.safebrowsing.provider.google.updateURL" = "";
  # "browser.safebrowsing.downloads.enabled" = false;
  "browser.safebrowsing.downloads.remote.enabled" = false;
  #   "browser.safebrowsing.downloads.remote.url" = "";
  #   "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
  #   "browser.safebrowsing.downloads.remote.block_uncommon" = false;
  # "browser.safebrowsing.allowOverride" = true;

  #############################################################
  # SECTION: MOZILLA
  #############################################################

  # "accessibility.force_disabled" = 1;
  #   "devtools.accessibility.enabled" = false;
  # "identity.fxaccounts.enabled" = false;
  #   "identity.fxaccounts.autoconfig.uri" = "";

  #############################################################
  # SECTION: TELEMETRY
  #############################################################

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
  # "toolkit.telemetry.dap_enabled" = false;
  "toolkit.telemetry.coverage.opt-out" = true;
  "toolkit.coverage.opt-out" = true;
  "toolkit.coverage.endpoint.base" = "";
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;
  # "datareporting.usage.uploadEnabled" = false;

  #############################################################
  # SECTION: EXPERIMENTS
  #############################################################

  "app.shield.optoutstudies.enabled" = false;
  "app.normandy.enabled" = false;
  "app.normandy.api_url" = "";

  #############################################################
  # SECTION: CRASH REPORTS
  #############################################################

  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = false;
  # "browser.crashReports.unsubmittedCheck.enabled" = false;

  #############################################################
  # SECTION: DETECTION
  #############################################################

  "captivedetect.canonicalURL" = "";
  "network.captive-portal-service.enabled" = false;
  "network.connectivity-service.enabled" = false;
  # "dom.private-attribution.submission.enabled" = false;
  #   "toolkit.telemetry.dap_helper" = "";
  #   "toolkit.telemetry.dap_leader" = "";
  # "default-browser-agent.enabled" = false;
  # "extensions.abuseReport.enabled" = false;
  # "browser.search.serpEventTelemetryCategorization.enabled" = false;
  # "doh-rollout.disable-heuristics" = true;
  # "dom.security.unexpected_system_load_telemetry_enabled" = false;
  # "messaging-system.rsexperimentloader.enabled" = false;
  # "network.trr.confirmation_telemetry_enabled" = false;
  # "security.app_menu.recordEventTelemetry" = false;
  # "security.certerrors.mitm.priming.enabled" = false;
  # "security.certerrors.recordEventTelemetry" = false;
  # "security.protectionspopup.recordEventTelemetry" = false;
  # "signon.recipes.remoteRecipes.enabled" = false;
  # "privacy.trackingprotection.emailtracking.data_collection.enabled" = false;
  # "messaging-system.askForFeedback" = true;  # DEFAULT [FF120+]
}
