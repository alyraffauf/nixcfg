{
  # ****************************************************************************
  # Peskyfox
  # "Aquila non capit muscas"
  # priority: remove annoyances
  # version: 137
  # url: https://github.com/yokoffing/Betterfox
  # credit: Some prefs are reproduced and adapted from the arkenfox project
  # credit URL: https://github.com/arkenfox/user.js
  # ****************************************************************************

  #############################################################
  # SECTION: MOZILLA UI
  #############################################################

  "browser.privatebrowsing.vpnpromourl" = "";
  # "browser.vpn_promo.enabled" = false;

  "extensions.getAddons.showPane" = false;
  "extensions.htmlaboutaddons.recommendations.enabled" = false;

  "browser.discovery.enabled" = false;

  "browser.shell.checkDefaultBrowser" = false;

  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

  "browser.preferences.moreFromMozilla" = false;

  "browser.aboutConfig.showWarning" = false;

  "browser.aboutwelcome.enabled" = false;
  # "browser.startup.homepage_override.mstone" = "ignore";
  # "startup.homepage_welcome_url" = "";
  # "startup.homepage_welcome_url.additional" = "";
  # "startup.homepage_override_url" = "";

  "browser.profiles.enabled" = true;

  # "widget.gtk.non-native-titlebar-buttons.enabled" = true;

  #############################################################
  # SECTION: THEME ADJUSTMENTS
  #############################################################

  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "browser.compactmode.show" = true;
  # "browser.theme.dark-private-windows" = false;
  # "browser.search.widget.inNavBar" = true;

  "layout.css.prefers-color-scheme.content-override" = 2;

  "browser.privateWindowSeparation.enabled" = false;

  #############################################################
  # SECTION: COOKIE BANNER HANDLING
  #############################################################

  # "cookiebanners.service.mode" = 1;
  # "cookiebanners.service.mode.privateBrowsing" = 1;
  # "cookiebanners.service.enableGlobalRules" = true;
  # "cookiebanners.service.enableGlobalRules.subFrames" = true;

  #############################################################
  # SECTION: TRANSLATIONS
  #############################################################

  # "browser.translations.enable" = true;
  # "browser.translations.autoTranslate" = true;

  #############################################################
  # SECTION: FULLSCREEN NOTICE
  #############################################################

  "full-screen-api.transition-duration.enter" = "0 0";
  "full-screen-api.transition-duration.leave" = "0 0";

  "full-screen-api.warning.delay" = -1;
  "full-screen-api.warning.timeout" = 0;

  #############################################################
  # SECTION: FONT APPEARANCE
  #############################################################

  # "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
  # "gfx.font_rendering.cleartype_params.rendering_mode" = 5;
  # "gfx.font_rendering.cleartype_params.cleartype_level" = 100;
  # "gfx.font_rendering.cleartype_params.force_gdi_classic_for_families" = "";
  # "gfx.font_rendering.directwrite.use_gdi_table_loading" = false;
  # "gfx.font_rendering.cleartype_params.gamma" = 1750;
  # "gfx.font_rendering.cleartype_params.enhanced_contrast" = 100;
  # "gfx.font_rendering.cleartype_params.pixel_structure" = 1;
  # "gfx.use_text_smoothing_setting" = true;

  #############################################################
  # SECTION: URL BAR
  #############################################################

  # "browser.urlbar.suggest.history" = false;
  # "browser.urlbar.suggest.bookmark" = true;
  # "browser.urlbar.suggest.clipboard" = false;
  # "browser.urlbar.suggest.openpage" = false;

  "browser.urlbar.suggest.engines" = false;
  # "browser.urlbar.suggest.searches" = false;

  # "browser.urlbar.quickactions.enabled" = false;
  # "browser.urlbar.shortcuts.quickactions" = false;
  # "browser.urlbar.suggest.weather" = true;

  "browser.urlbar.unitConversion.enabled" = true;
  "browser.urlbar.trending.featureGate" = false;

  #############################################################
  # SECTION: NEW TAB PAGE
  #############################################################

  # "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = true;

  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
  "browser.newtabpage.activity-stream.showSponsored" = false;

  "browser.newtabpage.activity-stream.default.sites" = "";

  #############################################################
  # SECTION: POCKET
  #############################################################

  "extensions.pocket.enabled" = false;

  #############################################################
  # SECTION: DOWNLOADS
  #############################################################

  # "browser.download.folderList" = 1;
  # "browser.download.always_ask_before_handling_new_types" = true;
  # "browser.download.useDownloadDir" = false;
  # "browser.download.autohideButton" = true;

  "browser.download.manager.addToRecentDocs" = false;

  #############################################################
  # SECTION: PDF
  #############################################################

  # "pdfjs.disabled" = false;
  # "browser.helperApps.showOpenOptionForPdfJS" = true;

  "browser.download.open_pdf_attachments_inline" = true;

  #############################################################
  # SECTION: TAB BEHAVIOR
  #############################################################

  # "browser.search.openintab" = true;
  # "browser.urlbar.openintab" = true;

  "browser.bookmarks.openInTabClosesMenu" = false;
  "browser.menu.showViewImageInfo" = true;
  "findbar.highlightAll" = true;
  "layout.word_select.eat_space_to_next_word" = false;
}
