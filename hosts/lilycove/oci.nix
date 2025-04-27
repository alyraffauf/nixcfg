{...}: {
  systemd.tmpfiles.rules = [
    "d /mnt/Data/dizquetv 0755 root root"
    "d /mnt/Data/tubesync/config/ 0755 root root"
  ];

  virtualisation.oci-containers.containers = {
    dizquetv = {
      image = "vexorian/dizquetv:latest";
      extraOptions = ["--pull=always"];
      ports = ["0.0.0.0:8000:8000"];

      volumes = [
        "/mnt/Data/dizquetv:/home/node/app/.dizquetv"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    tubesync = {
      environment.TUBESYNC_WORKERS = "8";
      extraOptions = ["--pull=always"];
      image = "ghcr.io/meeb/tubesync:latest";
      ports = ["0.0.0.0:14848:4848"];

      volumes = [
        "/mnt/Data/tubesync/config/:/config"
        "/mnt/Media/YouTube/:/downloads"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
  };
}
