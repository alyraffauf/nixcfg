{
  config,
  pkgs,
  ...
}: let
  mediaDirectory = "/mnt/Media";
in {
  services = {
    bazarr = {
      enable = true;
      openFirewall = true; # Port: 6767
    };

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

      package = pkgs.transmission_4.overrideAttrs (old: rec {
        src = pkgs.fetchFromGitHub {
          owner = "transmission";
          repo = "transmission";
          rev = version;
          hash = "sha256-gd1LGAhMuSyC/19wxkoE2mqVozjGPfupIPGojKY0Hn4=";
          fetchSubmodules = true;
        };

        version = "4.0.5";
      });

      settings = {
        blocklist-enabled = true;
        blocklist-url = "https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/bt_blocklists.gz";
        download-dir = mediaDirectory;
        encryption = 1;
        incomplete-dir = "${config.services.transmission.home}/.incomplete";
        incomplete-dir-enabled = true;
        peer-port = 5143;
        rpc-bind-address = "0.0.0.0";
        rpc-port = 9091;
      };

      webHome = pkgs.flood-for-transmission;
    };
  };
}
