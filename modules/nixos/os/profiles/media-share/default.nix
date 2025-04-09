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
        "cache=strict"
        "fsc" # Enables FS-Cache
        "gid=100"
        "nofail"
        "uid=${toString config.users.users.aly.uid}"
        "user=guest"
        "x-systemd.after=network.target"
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
