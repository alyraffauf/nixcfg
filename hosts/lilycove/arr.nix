{config, ...}: let
  dataDirectory = "/mnt/Data";
in {
  networking.firewall.allowedTCPPorts = [5143 6881];

  services = {
    bazarr = {
      enable = true;
      openFirewall = true; # Port: 6767
    };

    lidarr = {
      enable = true;
      dataDir = "${dataDirectory}/lidarr/.config/Lidarr";
      openFirewall = true; # Port: 8686
    };

    prowlarr = {
      enable = true;
      openFirewall = true; # Port: 9696
    };

    radarr = {
      enable = true;
      dataDir = "${dataDirectory}/radarr/.config/Radarr/";
      openFirewall = true; # Port: 7878
    };

    readarr = {
      enable = true;
      dataDir = "${dataDirectory}/readarr/";
      openFirewall = true; # Port: 8787
    };

    sonarr = {
      enable = true;
      dataDir = "${dataDirectory}/sonarr/.config/NzbDrone/";
      openFirewall = true; # Port: 8989
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d ${config.services.lidarr.dataDir} 0755 lidarr lidarr"
      "d ${config.services.radarr.dataDir} 0755 radarr radarr"
      "d ${config.services.readarr.dataDir} 0755 readarr readarr"
      "d ${config.services.sonarr.dataDir} 0755 sonarr sonarr"
    ];
  };
}
