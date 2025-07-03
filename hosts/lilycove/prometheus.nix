{config, ...}: {
  services.prometheus.exporters = {
    exportarr-bazarr = {
      enable = true;
      apiKeyFile = config.age.secrets.bazarrApiKey.path;
      port = 9708;
      url = "https://${config.mySnippets.tailnet.networkMap.bazarr.vHost}";
    };

    exportarr-lidarr = {
      enable = true;
      apiKeyFile = config.age.secrets.lidarrApiKey.path;
      port = 9709;
      url = "https://${config.mySnippets.tailnet.networkMap.lidarr.vHost}";
    };

    exportarr-prowlarr = {
      enable = true;
      apiKeyFile = config.age.secrets.prowlarrApiKey.path;
      port = 9710;
      url = "https://${config.mySnippets.tailnet.networkMap.prowlarr.vHost}";
    };

    exportarr-radarr = {
      enable = true;
      apiKeyFile = config.age.secrets.radarrApiKey.path;
      port = 9711;
      url = "https://${config.mySnippets.tailnet.networkMap.radarr.vHost}";
    };

    exportarr-sonarr = {
      enable = true;
      apiKeyFile = config.age.secrets.sonarrApiKey.path;
      port = 9712;
      url = "https://${config.mySnippets.tailnet.networkMap.sonarr.vHost}";
    };

    smartctl.enable = true;
  };
}
