{
  config,
  lib,
  pkgs,
  ...
}: let
  # Compute a list of Btrfs file systems (with mountPoint and device)
  btrfsFS = let
    isDeviceInList = list: device: builtins.filter (e: e.device == device) list != [];
    uniqueDeviceList = lib.foldl' (acc: e:
      if isDeviceInList acc e.device
      then acc
      else acc ++ [e]) [];
  in
    uniqueDeviceList (
      lib.mapAttrsToList (name: fs: {
        mountPoint = fs.mountPoint;
        device = fs.device;
      }) (lib.filterAttrs (name: fs: fs.fsType == "btrfs") config.fileSystems)
    );
in {
  options.myNixOS.profiles.btrfs.enable = lib.mkEnableOption "btrfs filesystem configuration";

  config = lib.mkIf config.myNixOS.profiles.btrfs.enable {
    boot.supportedFilesystems = ["btrfs"];
    environment.systemPackages = lib.optionals (config.services.xserver.enable) [pkgs.snapper-gui];

    services = lib.mkIf (builtins.length btrfsFS > 0) {
      btrfs.autoScrub.enable = true;

      snapper = {
        configs.home = {
          ALLOW_GROUPS = ["users"];
          FSTYPE = "btrfs";
          SUBVOLUME = "/home";
          TIMELINE_CLEANUP = true;
          TIMELINE_CREATE = true;
        };

        persistentTimer = true;
      };
    };
  };
}
