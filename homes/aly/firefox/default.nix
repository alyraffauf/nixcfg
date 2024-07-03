{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file = let
    source = builtins.fetchGit {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme.git";
      rev = "8fb5267c5b3434f76983e29749aba7cd636e03ca";
      ref = "master";
    };
  in {
    ".mozilla/firefox/default/chrome" = {inherit source;};
    ".mozilla/firefox/work/chrome" = {inherit source;};
  };

  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          decentraleyes
          keepassxc-browser
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
            "Brave" = {
              definedAliases = ["!brave"];
              icon = "${pkgs.brave}/share/icons/hicolor/24x24/apps/brave-browser.png";

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

            "Kagi" = {
              definedAliases = ["!kagi"];
              icon = ./kagi.png;

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

            "Bing" = {
              metaData = {
                hidden = true;
                alias = "!bing";
              };
            };

            "Google" = {
              metaData = {
                hidden = true;
                alias = "!google";
              };
            };
          };
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
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          clearurls
          consent-o-matic
          decentraleyes
          keepassxc-browser
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
            "Bing" = {
              metaData = {
                hidden = true;
                alias = "!bing";
              };
            };

            "DuckDuckGo" = {
              metaData = {
                hidden = true;
                alias = "!ddg";
              };
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
