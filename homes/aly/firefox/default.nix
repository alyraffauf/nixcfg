{
  lib,
  pkgs,
  ...
}: let
  engines = import ./engines.nix;
in {
  programs.firefox = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin (pkgs.runCommand "firefox-0.0.0" {} "mkdir $out");

    profiles = {
      default = {
        containersForce = true;

        containers = {
          personal = {
            color = "purple";
            icon = "circle";
            id = 1;
            name = "Personal";
          };

          private = {
            color = "red";
            icon = "fingerprint";
            id = 2;
            name = "Private";
          };

          atolls = {
            color = "blue";
            icon = "briefcase";
            id = 3;
            name = "Atolls";
          };
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
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
          default = "DuckDuckGo";
          force = true;

          order = [
            "Bing"
            "Brave"
            "DuckDuckGo"
            "Google"
            "Home Manager Options"
            "Kagi"
            "NixOS Wiki"
            "nixpkgs"
            "Noogle"
            "Wikipedia"
            "Wiktionary"
          ];
        };

        settings =
          (import ./betterfox.nix)
          // {
            "browser.toolbars.bookmarks.visibility" = "newtab";
            # "services.sync.prefs.sync.browser.uiCustomization.state" = true;
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "svg.context-properties.content.enabled" = true;
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
