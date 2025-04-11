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
        message = "NFS connects to mauville shares over tailscale, but services.tailscale.enable != true.";
      }
    ];

    environment.systemPackages = [pkgs.nfs-utils];

    fileSystems = let
      fsType = "nfs";
      options = [
        "default"
        "noatime"
        "nofail"
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
        device = "mauville:/mnt/Media";
      };
    };

    home-manager.sharedModules = [
      {
        gtk.gtk3.bookmarks = [
          "file:///mnt/Media"
        ];
      }
    ];

    services.cachefilesd = {
      enable = true;

      extraConfig = ''
        # Limit cache size
        brun 25%     # Start cleaning when <10% space left
        bcull 15%    # Aggressively clean if <7%
        bstop 10%    # Stop caching if <3% space left

        frun 95%     # Clean if >95% files used
        fcull 90%    # Aggressively clean >90%
        fstop 80%    # Stop caching if >80% inodes used
      '';
    };
  };
}
