{lib, ...}: {
  options.mySnippets.cute-haus.networkMap = lib.mkOption {
    type = lib.types.attrs;
    description = "Hostnames, ports, and vHosts for cute.haus services.";

    default = {
      aly-codes = {
        hostName = "mossdeep";
        port = 8282;
        vHost = "aly.codes";
      };

      aly-social = {
        hostName = "mossdeep";
        port = 3000;
        vHost = "aly.social";
      };

      audiobookshelf = {
        hostName = "mauville";
        port = 13378;
        vHost = "audiobookshelf.cute.haus";
      };

      glance = {
        hostName = "mauville";
        port = 8080;
        vHost = "cute.haus";
      };

      forgejo = {
        hostName = "mossdeep";
        port = 3001;
        vHost = "git.aly.codes";
      };

      immich = {
        hostName = "lilycove";
        port = 2283;
        vHost = "immich.cute.haus";
      };

      karakeep = {
        hostName = "mauville";
        port = 7020;
        vHost = "karakeep.cute.haus";
      };

      ombi = {
        hostName = "lilycove";
        port = 5000;
        vHost = "ombi.cute.haus";
      };

      plex = {
        hostName = "lilycove";
        port = 32400;
        vHost = "plex.cute.haus";
      };

      uptime-kuma = {
        hostName = "verdanturf";
        port = 3001;
        vHost = "uptime-kuma.cute.haus";
      };

      vaultwarden = {
        hostName = "verdanturf";
        port = 8222;
        vHost = "vaultwarden.cute.haus";
      };
    };
  };
}
