_: {
  flake.nixosModules.sootopolis = {
    disko.devices.disk.main = {
      device = "/dev/disk/by-id/nvme-eui.ace42e0035f3f4482ee4ac0000000001";
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

          cryptroot = {
            size = "100%";

            content = {
              name = "cryptroot";
              type = "luks";

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
  };
}
