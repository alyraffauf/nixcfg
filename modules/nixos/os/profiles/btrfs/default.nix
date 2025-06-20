{
  config,
  lib,
  pkgs,
  ...
}: let
  # Compute a list of Btrfs file systems (with mountPoint and device)
  btrfsFSDevices = let
    # Helper: does a device already appear in the accumulator?
    isDeviceInList = list: device:
      builtins.any (e: e.device == device) list;

    # Helper: keep only the first occurrence of each device
    uniqueDeviceList = lib.foldl' (
      acc: e:
        if isDeviceInList acc e.device
        then acc
        else acc ++ [e]
    ) [];
  in
    uniqueDeviceList (
      lib.mapAttrsToList (_: fs: {
        inherit (fs) mountPoint device;
      })
      (lib.filterAttrs (_: fs: fs.fsType == "btrfs") config.fileSystems)
    );

  # Create beesd.filesystems attrset keyed by device basename, with spec = device path
  beesdConfig = lib.listToAttrs (map (fs: {
      name = lib.strings.sanitizeDerivationName (baseNameOf fs.device);

      value = {
        hashTableSizeMB = 2048;
        spec = fs.device;
        verbosity = "info";

        extraOptions = [
          "--loadavg-target"
          "1.0"
          "--thread-factor"
          "0.50"
        ];
      };
    })
    btrfsFSDevices);

  # Check if a btrfs /home entry exists
  hasHomeSubvolume =
    lib.hasAttr "/home" config.fileSystems
    && config.fileSystems."/home".fsType == "btrfs";
in {
  options.myNixOS.profiles.btrfs = {
    enable = lib.mkEnableOption "btrfs filesystem configuration";
    deduplicate = lib.mkEnableOption "deduplicate btrfs filesystems";
  };

  config = lib.mkIf config.myNixOS.profiles.btrfs.enable {
    boot.supportedFilesystems = ["btrfs"];
    environment.systemPackages = lib.optionals config.services.xserver.enable [pkgs.snapper-gui];

    services = lib.mkIf (btrfsFSDevices != []) {
      beesd.filesystems = lib.mkIf config.myNixOS.profiles.btrfs.deduplicate beesdConfig;
      btrfs.autoScrub.enable = true;

      snapper = {
        configs.home = lib.mkIf hasHomeSubvolume {
          ALLOW_GROUPS = ["users"];
          FSTYPE = "btrfs";
          SUBVOLUME = "/home";
          TIMELINE_CLEANUP = true;
          TIMELINE_CREATE = true;
        };

        filters = ''
          -.bash_profile
          -.bashrc
          -.cache
          -.config
          -.librewolf
          -.local
          -.mozilla
          -.nix-profile
          -.pki
          -.share
          -.snapshots
          -.thunderbird
          -.zshrc
        '';

        persistentTimer = true;
      };
    };
  };
}
