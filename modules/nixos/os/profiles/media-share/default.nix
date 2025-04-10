{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.media-share.enable = lib.mkEnableOption "media share";
  config = lib.mkIf config.myNixOS.profiles.media-share.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "Samba connects to mauville shares over tailscale, but services.tailscale.enable != true.";
      }
    ];

    environment.systemPackages = [pkgs.cifs-utils];

    fileSystems = let
      fsType = "cifs";
      options = [
        "actimeo=30" # Cache metadata (stat) for 30s
        "cache=strict" # Accurate file metadata for Plex
        "fsc" # Enable FS-Cache (persistent disk caching)
        "gid=100"
        "nofail" # Don’t break boot if share is unavailable
        "noperm" # Skip permission checks on client side
        "noserverino" # Avoid inode mismatch errors with Plex
        "nounix" # Avoid Unix extensions; improve compatibility
        "password="
        "rsize=1048576" # Read buffer size (1MB)
        "rw" # Explicitly enable read/write
        "uid=${toString config.users.users.aly.uid}"
        "user=guest"
        "wsize=1048576" # Write buffer size (1MB)
        "x-systemd.after=network-online.target"
        "x-systemd.after=tailscaled.service"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
      ];
    in {
      "/mnt/Media" = {
        inherit options fsType;
        device = "//mauville/Media";
      };
    };

    home-manager.sharedModules = [
      {
        gtk.gtk3.bookmarks = [
          "file:///mnt/Media"
        ];
      }
    ];

    services.cachefilesd.enable = true;
  };
}
