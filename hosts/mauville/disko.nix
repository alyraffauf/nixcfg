{
  disko.devices = {
    disk = {
      media = {
        type = "disk";
        device = "/dev/sdb";

        content = {
          type = "gpt";

          partitions = {
            root = {
              size = "100%";

              content = {
                type = "btrfs";
                # extraArgs = ["-f"]; # Override existing partition
                mountpoint = "/mnt/Media";
                mountOptions = ["compress=zstd" "noatime"];
              };
            };
          };
        };
      };

      vdb = {
        type = "disk";
        device = "/dev/sda";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              content = {
                format = "vfat";

                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];

                mountpoint = "/boot";
                type = "filesystem";
              };

              size = "1024M";
              type = "EF00";
            };

            luks = {
              size = "100%";

              content = {
                type = "luks";
                name = "crypted";

                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];

                  subvolumes = {
                    "/root" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/";
                    };

                    "persist" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/persist";
                    };

                    "/home" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/home";
                    };

                    "/home/.snapshots" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/home/.snapshots";
                    };

                    "/nix" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/nix";
                    };
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
