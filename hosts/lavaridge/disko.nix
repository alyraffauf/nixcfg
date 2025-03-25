{
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        device = "/dev/nvme0n1";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1024M";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            root = {
              size = "100%";

              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "rootfs" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/";
                  };
                  # Subvolume name is the same as the mountpoint
                  "home" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/home";
                  };

                  "/home/.snapshots" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/home/.snapshots";
                  };

                  # Parent is not mounted so the mountpoint must be set
                  "nix" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/nix";
                  };
                };

                mountpoint = "/partition-root";
              };
            };
          };
        };
      };
    };
  };
}
