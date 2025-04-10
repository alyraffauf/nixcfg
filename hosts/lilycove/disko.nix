{
  disko.devices = {
    disk = {
      archive = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000DM001-1ER164_Z4Z6TRAQ";

        content = {
          type = "gpt";

          partitions = {
            root = {
              size = "100%";

              content = {
                type = "btrfs";

                subvolumes = {
                  "/root" = {
                    mountpoint = "/mnt/Files";
                    mountOptions = ["compress=zstd" "noatime"];
                  };

                  "/.snapshots" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/mnt/Files/.snapshots";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
