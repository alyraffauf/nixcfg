{config, ...}: {
  services.prometheus.exporters = {
    exportarr-bazarr = {
      enable = true;
      apiKeyFile = config.age.secrets.bazarrApiKey.path;
      port = 9708;
      url = "https://bazarr.${config.mySnippets.tailnet.name}";
    };

    exportarr-lidarr = {
      enable = true;
      apiKeyFile = config.age.secrets.lidarrApiKey.path;
      port = 9709;
      url = "https://lidarr.${config.mySnippets.tailnet.name}";
    };

    exportarr-prowlarr = {
      enable = true;
      apiKeyFile = config.age.secrets.prowlarrApiKey.path;
      port = 9710;
      url = "https://prowlarr.${config.mySnippets.tailnet.name}";
    };

    exportarr-radarr = {
      enable = true;
      apiKeyFile = config.age.secrets.radarrApiKey.path;
      port = 9711;
      url = "https://radarr.${config.mySnippets.tailnet.name}";
    };

    exportarr-sonarr = {
      enable = true;
      apiKeyFile = config.age.secrets.sonarrApiKey.path;
      port = 9712;
      url = "https://sonarr.${config.mySnippets.tailnet.name}";
    };

    smartctl.enable = true;
  };
}
