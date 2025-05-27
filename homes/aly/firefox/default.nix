{
  lib,
  pkgs,
  ...
}: let
  engines = import ./engines.nix;
in {
  programs.firefox = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null;

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
          consent-o-matic
          simple-tab-groups
          ublock-origin
        ];

        id = 0;

        search = {
          inherit engines;
          default = "ddg";
          force = true;

          order = [
            "bing"
            "Brave"
            "ddg"
            "google"
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
          (import ./betterfox)
          // (import ./betterfox/fastfox.nix)
          // (import ./betterfox/peskyfox.nix)
          // (import ./betterfox/securefox.nix)
          // (import ./betterfox/smoothfox.nix)
          // {
            "browser.tabs.groups.enabled" = true;
            "browser.tabs.groups.smart.enabled" = true;
            "browser.toolbars.bookmarks.visibility" = "newtab";
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "svg.context-properties.content.enabled" = true;
            # "services.sync.prefs.sync.browser.uiCustomization.state" = true;
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

  stylix.targets.firefox.profileNames = ["default"];
}
