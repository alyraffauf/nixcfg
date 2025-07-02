{config, ...}: {
  services = {
    # ddclient = {
    #   enable = true;

    #   domains = [
    #     "couchdb.${newDomain}"
    #   ];

    #   interval = "10min";
    #   passwordFile = config.age.secrets.cloudflare.path;
    #   protocol = "cloudflare";
    #   ssl = true;
    #   username = "token";
    #   zone = newDomain;

    #   extraConfig = ''
    #     zone=raffauflabs.com
    #     couch.${oldDomain}
    #   '';
    # };

    caddy = {
      email = "alyraffauf@fastmail.com";

      virtualHosts = {
        "couchdb.${config.mySnippets.tailnet}" = {
          extraConfig = ''
            bind tailscale/couchdb
            encode zstd gzip
            reverse_proxy localhost:${toString config.services.couchdb.port}
          '';
        };
      };
    };
  };
}
