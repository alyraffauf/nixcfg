_: {
  flake.nixosModules.mauville = {
    disko.devices.disk.main = {
      device = "/dev/disk/by-id/ata-512GB_SSD_PK6908R006578";
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";

            content = {
              format = "vfat";
              mountOptions = ["umask=0077"];
              mountpoint = "/boot";
              type = "filesystem";
            };
          };

          root = {
            size = "100%";

            content = {
              extraArgs = ["-f"];
              type = "btrfs";

              subvolumes = {
                "@" = {
                  mountOptions = ["compress=zstd" "noatime"];
                  mountpoint = "/";
                };

                "@home" = {
                  mountOptions = ["compress=zstd" "noatime"];
                  mountpoint = "/home";
                };

                "@nix" = {
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
}
