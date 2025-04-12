{config, ...}: let
  mediaDirectory = "/mnt/Media";
in {
  services = {
    lidarr = {
      enable = true;
      openFirewall = true; # Port: 8686
    };

    prowlarr = {
      enable = true;
      openFirewall = true; # Port: 9696
    };

    radarr = {
      enable = true;
      openFirewall = true; # Port: 7878
    };

    readarr = {
      enable = true;
      openFirewall = true; # Port: 8787
    };

    sonarr = {
      enable = true;
      openFirewall = true; # Port: 8989
    };

    transmission = {
      enable = true;
      credentialsFile = config.age.secrets.transmission.path;
      openFirewall = true;
      openRPCPort = true;

      settings = {
        blocklist-enabled = true;
        blocklist-url = "https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/bt_blocklists.gz";
        download-dir = mediaDirectory;
        peer-port = 5143;
        rpc-bind-address = "0.0.0.0";
        rpc-port = 9091;
      };
    };
  };
}
