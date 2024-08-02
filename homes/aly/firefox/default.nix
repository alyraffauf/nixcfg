{
  config,
  pkgs,
  ...
}: {
  home.file = let
    source = builtins.fetchGit {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme.git";
      rev = "cc70ec20e2775df7cd2bccdd20dcdecc3e0a733b";
      ref = "master";
    };
  in {
    ".mozilla/firefox/default/chrome".source = source;
    ".mozilla/firefox/work/chrome".source = source;
  };

  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          augmented-steam
          decentraleyes
          omnivore
          raindropio
          sidebery
          sponsorblock
          ublock-origin
          zoom-redirector
        ];

        id = 0;

        search = {
          default = "Brave";
          force = true;

          engines = {
            "Bing".metaData = {
              hidden = true;
              alias = "!bing";
            };

            "Brave" = {
              definedAliases = ["!brave"];
              iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-search-icon.CsIFM2aN.svg";
              updateInterval = 24 * 60 * 60 * 1000; # every day

              urls = [
                {
                  template = "https://search.brave.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "Google".metaData = {
              hidden = true;
              alias = "!google";
            };

            "Kagi" = {
              definedAliases = ["!kagi"];
              iconUpdateURL = "https://kagi.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day

              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "NixOS Wiki" = {
              definedAliases = ["!nw" "!nixwiki"];
              iconUpdateURL = "https://wiki.nixos.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day

              urls = [
                {
                  template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                }
              ];
            };

            "nixpkgs" = {
              definedAliases = ["!nix"];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "Wiktionary" = {
              definedAliases = ["!wikt"];
              iconUpdateURL = "https://en.wiktionary.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day

              urls = [
                {
                  template = "https://en.wiktionary.org/wiki/{searchTerms}";
                }
              ];
            };
          };

          order = [
            "Brave"
            "Kagi"
            "nixpkgs"
            "NixOS Wiki"
            "DuckDuckGo"
            "Wikipedia"
            "Wiktionary"
          ];
        };

        settings = {
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "network.cookie.cookieBehavior" = 1;
          "permissions.default.desktop-notification" = 2;
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.global-checkbox.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "services.sync.prefs.sync.browser.uiCustomization.state" = true;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };

      work = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          clearurls
          consent-o-matic
          decentraleyes
          ublock-origin
          zoom-redirector
        ];

        settings = {
          "browser.bookmarks.file" = "${./bookmarks-work.html}";
          "browser.places.importBookmarksHTML" = true;
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "identity.fxaccounts.enabled" = false;
          "network.cookie.cookieBehavior" = 1;
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.global-checkbox.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "signon.rememberSignons" = false;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        id = 1;

        search = {
          default = "Google";
          force = true;
          engines = {
            "Bing".metaData = {
              hidden = true;
              alias = "!bing";
            };

            "DuckDuckGo".metaData = {
              hidden = true;
              alias = "!ddg";
            };
          };
        };
      };
    };
  };

  xdg.desktopEntries.firework = {
    categories = ["Application" "Network" "WebBrowser"];
    exec = "firefox -p work --name firework %U";
    genericName = "Web Browser";
    icon = "firefox";
    mimeType = ["text/html" "text/xml"];
    name = "Firefox (work)";
    settings = {StartupWMClass = "firework";};
    startupNotify = true;
    terminal = false;
  };
}
