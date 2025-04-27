{...}: {
  virtualisation.oci-containers.containers.tubesync = {
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
}
