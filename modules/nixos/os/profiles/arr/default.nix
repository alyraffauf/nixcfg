{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.arr = {
    enable =
      lib.mkEnableOption "*arr services";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib";
      description = "The directory where *arr stores its data files.";
    };
  };

  config = lib.mkIf config.myNixOS.profiles.arr.enable {
    services = {
      lidarr = {
        enable = true;
        dataDir = "${config.myNixOS.profiles.arr.dataDir}/lidarr/.config/Lidarr";
        openFirewall = true; # Port: 8686
      };

      prowlarr = {
        enable = true;
        openFirewall = true; # Port: 9696
      };

      radarr = {
        enable = true;
        dataDir = "${config.myNixOS.profiles.arr.dataDir}/radarr/.config/Radarr/";
        openFirewall = true; # Port: 7878
      };

      readarr = {
        enable = true;
        dataDir = "${config.myNixOS.profiles.arr.dataDir}/readarr/";
        openFirewall = true; # Port: 8787
      };

      sonarr = {
        enable = true;
        dataDir = "${config.myNixOS.profiles.arr.dataDir}/sonarr/.config/NzbDrone/";
        openFirewall = true; # Port: 8989
      };
    };

    myNixOS.services.bazarr = {
      enable = true;
      dataDir = "${config.myNixOS.profiles.arr.dataDir}/bazarr";
      openFirewall = true; # Port: 6767
    };

    systemd = {
      tmpfiles.rules = [
        "d ${config.myNixOS.services.bazarr.dataDir} 0755 bazarr bazarr"
        "d ${config.services.lidarr.dataDir} 0755 lidarr lidarr"
        "d ${config.services.radarr.dataDir} 0755 radarr radarr"
        "d ${config.services.readarr.dataDir} 0755 readarr readarr"
        "d ${config.services.sonarr.dataDir} 0755 sonarr sonarr"
      ];
    };
  };
}
