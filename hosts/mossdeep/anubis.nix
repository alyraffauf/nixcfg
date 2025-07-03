{config, ...}: {
  services.anubis = {
    defaultOptions.settings = {
      DIFFICULTY = 4;
      OG_CACHE_CONSIDER_HOST = true;
      OG_PASSTHROUGH = true;
      # SERVE_ROBOTS_TXT = true;
      WEBMASTER_EMAIL = "aly@aly.codes";
    };

    instances = {
      forgejo.settings = {
        TARGET = "http://${config.mySnippets.cute-haus.networkMap.forgejo.hostName}:${toString config.mySnippets.cute-haus.networkMap.forgejo.port}";
        BIND = ":60123";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20123";
        METRICS_BIND_NETWORK = "tcp";
      };
    };
  };
}
