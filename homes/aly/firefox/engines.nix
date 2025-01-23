{
  "Bing" = {
    metaData = {
      hidden = false;
      alias = "!bing";
    };
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

  "Google" = {
    metaData = {
      hidden = false;
      alias = "!google";
    };
  };

  "Home Manager Options" = {
    iconUpdateURL = "https://home-manager-options.extranix.com/images/favicon.png";
    definedAliases = ["!hm"];
    metaData.hidden = true;

    urls = [
      {
        template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
      }
    ];
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
    metaData.hidden = true;

    urls = [
      {
        template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
      }
    ];
  };

  "nixpkgs" = {
    definedAliases = ["!nix"];
    icon = "${./nix-snowflake.svg}";

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

  "Noogle" = {
    definedAliases = ["!noogle"];
    iconUpdateURL = "https://noogle.dev/favicon.png";
    metaData.hidden = true;

    urls = [
      {
        template = "https://noogle.dev/q?term={searchTerms}";
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
}
