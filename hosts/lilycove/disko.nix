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
                    mountpoint = "/mnt/Data";
                    mountOptions = ["compress=zstd" "noatime" "nofail"];
                  };

                  "/.snapshots" = {
                    mountOptions = ["compress=zstd" "noatime" "nofail"];
                    mountpoint = "/mnt/Data/.snapshots";
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
