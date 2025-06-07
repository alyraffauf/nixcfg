{config, ...}: {
  services.anubis = {
    defaultOptions.settings = {
      DIFFICULTY = 4;
      OG_CACHE_CONSIDER_HOST = true;
      OG_PASSTHROUGH = true;
      SERVE_ROBOTS_TXT = true;
      WEBMASTER_EMAIL = "aly@aly.codes";
    };

    instances = {
      # glance.settings = {
      #   TARGET = "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
      #   BIND = ":60723";
      #   BIND_NETWORK = "tcp";
      #   METRICS_BIND = "0.0.0.0:20723";
      #   METRICS_BIND_NETWORK = "tcp";
      # };

      uptime-kuma.settings = {
        TARGET = "http://localhost:${config.services.uptime-kuma.settings.PORT}";
        BIND = ":60823";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20823";
        METRICS_BIND_NETWORK = "tcp";
      };
    };
  };
}
