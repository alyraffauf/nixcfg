{
  disko.devices = {
    disk = {
      media = {
        type = "disk";
        device = "/dev/sda";

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

      archive = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";

          partitions = {
            root = {
              size = "100%";

              content = {
                type = "btrfs";
                mountpoint = "/mnt/Archive";
                mountOptions = ["compress=zstd" "noatime"];
              };
            };
          };
        };
      };

      vdb = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1024M";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
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
