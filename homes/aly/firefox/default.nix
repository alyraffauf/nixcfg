{pkgs, ...}: let
  engines = import ./engines.nix;
in {
  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          bitwarden
          clearurls
          consent-o-matic
          raindropio
          simple-tab-groups
          ublock-origin
          zoom-redirector
        ];

        id = 0;

        search = {
          inherit engines;
          default = "Brave";
          force = true;

          order = [
            "Brave"
            "Bing"
            "Kagi"
            "Google"
            "nixpkgs"
            "Home Manager Options"
            "NixOS Wiki"
            "Noogle"
            "DuckDuckGo"
            "Wikipedia"
            "Wiktionary"
          ];
        };

        settings =
          (import ./betterfox.nix)
          // {
            "browser.toolbars.bookmarks.visibility" = "newtab";
            "network.cookie.cookieBehavior" = 1;
            "privacy.fingerprintingProtection" = true;
            "privacy.trackingprotection.emailtracking.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.global-checkbox.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "services.sync.prefs.sync.browser.uiCustomization.state" = true;
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "svg.context-properties.content.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
      };

      # work = {
      #   extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #     bitwarden
      #     clearurls
      #     consent-o-matic
      #     ublock-origin
      #     zoom-redirector
      #   ];

      #   settings =
      #     (import ./betterfox.nix)
      #     // {
      #       "browser.bookmarks.file" = "${./bookmarks-work.html}";
      #       "browser.places.importBookmarksHTML" = true;
      #       "browser.toolbars.bookmarks.visibility" = "newtab";
      #       "identity.fxaccounts.enabled" = false;
      #       "sidebar.revamp" = true;
      #       "sidebar.verticalTabs" = true;
      #       "signon.rememberSignons" = false;
      #     };

      #   id = 1;

      #   search = {
      #     default = "Google";
      #     force = true;

      #     engines = {
      #       "Bing".metaData = {
      #         hidden = true;
      #         alias = "!bing";
      #       };

      #       "DuckDuckGo".metaData = {
      #         hidden = true;
      #         alias = "!ddg";
      #       };
      #     };
      #   };
      # };

    };
  };

  # xdg.desktopEntries.firework = {
  #   categories = ["Application" "Network" "WebBrowser"];
  #   exec = "firefox -p work --name firework %U";
  #   genericName = "Web Browser";
  #   icon = "firefox";
  #   mimeType = ["text/html" "text/xml"];
  #   name = "Firefox (work)";
  #   settings = {StartupWMClass = "firework";};
  #   startupNotify = true;
  #   terminal = false;
  # };
}
