_: {
  flake.nixosModules.mauville = {
    fileSystems."/mnt/Storage" = {
      device = "/dev/disk/by-id/ata-CT2000BX500SSD1_2345E8842829";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime" "nofail"];
    };
  };
}
