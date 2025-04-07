{
  config,
  lib,
  pkgs,
  ...
}: let
  # Compute a list of Btrfs file systems (with mountPoint and device)
  btrfsFSDevices = let
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

  # Create beesd.filesystems attrset keyed by device basename, with spec = device path
  beesdConfig = lib.listToAttrs (map (fs: {
      name = lib.strings.sanitizeDerivationName (baseNameOf fs.device);
      value = {
        spec = fs.device;
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = ["--loadavg-target" "5.0"];
      };
    })
    btrfsFSDevices);
in {
  options.myNixOS.profiles.btrfs.enable = lib.mkEnableOption "btrfs filesystem configuration";

  config = lib.mkIf config.myNixOS.profiles.btrfs.enable {
    boot.supportedFilesystems = ["btrfs"];
    environment.systemPackages = lib.optionals (config.services.xserver.enable) [pkgs.snapper-gui];

    services = lib.mkIf (btrfsFSDevices != []) {
      beesd.filesystems = beesdConfig;
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
