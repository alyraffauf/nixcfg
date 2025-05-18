{config, ...}: {
  services.anubis = {
    defaultOptions.settings = {
      DIFFICULTY = 4;
      OG_CACHE_CONSIDER_HOST = true;
      OG_PASSTHROUGH = true;
      SERVE_ROBOTS_TXT = true;
      WEBMASTER_EMAIL = "hello@aly.codes";
    };

    instances = {
      audiobookshelf.settings = {
        TARGET = "http://mauville:13378";
        BIND = ":60923";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20923";
        METRICS_BIND_NETWORK = "tcp";
      };

      forgejo.settings = {
        TARGET = "http://mauville:3000";
        BIND = ":60823";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20823";
        METRICS_BIND_NETWORK = "tcp";
      };

      glance.settings = {
        TARGET = "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
        BIND = ":60723";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20723";
        METRICS_BIND_NETWORK = "tcp";
      };

      immich.settings = {
        TARGET = "http://lilycove:2283";
        BIND = ":60623";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20623";
        METRICS_BIND_NETWORK = "tcp";
      };

      ombi.settings = {
        TARGET = "http://lilycove:5000";
        BIND = ":60523";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20523";
        METRICS_BIND_NETWORK = "tcp";
      };

      plex.settings = {
        TARGET = "http://lilycove:32400";
        BIND = ":60423";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20423";
        METRICS_BIND_NETWORK = "tcp";
      };
    };
  };
}
