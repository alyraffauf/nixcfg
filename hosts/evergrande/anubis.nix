_: {
  services.anubis = {
    defaultOptions.settings = {
      DIFFICULTY = 4;
      OG_CACHE_CONSIDER_HOST = true;
      OG_PASSTHROUGH = true;
      # SERVE_ROBOTS_TXT = true;
      WEBMASTER_EMAIL = "aly@aly.codes";
    };

    instances = {
      alycodes.settings = {
        TARGET = "http://mossdeep:8282";
        BIND = ":60023";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "0.0.0.0:20023";
        METRICS_BIND_NETWORK = "tcp";
      };
    };
  };
}
