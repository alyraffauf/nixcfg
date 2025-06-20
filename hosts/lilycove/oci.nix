{...}: {
  systemd.tmpfiles.rules = [
    "d /mnt/Data/dizquetv 0755 root root"
    "d /mnt/Data/tubesync/config/ 0755 root root"
    "d /mnt/Data/arm/home 0755 1000 1000 - -"
    "d /mnt/Data/arm/config 0755 1000 1000 - -"
    "d /mnt/Data/arm 0755 1000 1000 - -"
  ];

  virtualisation.oci-containers.containers = {
    # arm = {
    #   autoStart = true;
    #   image = "automaticrippingmachine/automatic-ripping-machine:latest";
    #   ports = ["8181:8080"];

    #   volumes = [
    #     "/mnt/Data/arm/home:/home/arm"
    #     "/mnt/Data/arm/config:/etc/arm/config"
    #   ];

    #   extraOptions = [
    #     # Needed for ARM to work correctly - by default `CAP_SYS_ADMIN` is dropped
    #     # which blocks `mount()` calls within the container
    #     # This is needed in order to `mount /dev/sr0 /mnt/dev/sr0` for ripping, which may be avoidable by
    #     # handling mounts outside of the container, and having `/mnt/dev` bind mounted into the container.
    #     "--privileged"
    #     # Pass the CD/Bluray/DVD drive to the container
    #     "--device=/dev/sr0:/dev/sr0"
    #     "--pull=always"
    #   ];
    # };

    dizquetv = {
      image = "vexorian/dizquetv:latest";
      extraOptions = ["--pull=always"];
      ports = ["0.0.0.0:8000:8000"];

      volumes = [
        "/mnt/Data/dizquetv:/home/node/app/.dizquetv"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    # tubesync = {
    #   environment.TUBESYNC_WORKERS = "8";
    #   extraOptions = ["--pull=always"];
    #   image = "ghcr.io/meeb/tubesync:latest";
    #   ports = ["0.0.0.0:14848:4848"];

    #   volumes = [
    #     "/mnt/Data/tubesync/config/:/config"
    #     "/mnt/Media/YouTube/:/downloads"
    #     "/etc/localtime:/etc/localtime:ro"
    #   ];
    # };
  };
}
