{
  config,
  lib,
  ...
}: {
  fileSystems = let
    fsType = "cifs";
    options = [
      "gid=100"
      "guest"
      "nofail"
      "uid=${toString config.users.users.aly.uid}"
      "x-systemd.after=network.target"
      "x-systemd.after=tailscaled.service"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=5s"
    ];
  in
    lib.attrsets.optionalAttrs (config.networking.hostName != "mauville") {
      "/mnt/Archive" = {
        inherit options fsType;
        device = "//mauville/Archive";
      };

      "/mnt/Media" = {
        inherit options fsType;
        device = "//mauville/Media";
      };
    };

  home-manager.sharedModules = [
    {
      gtk.gtk3.bookmarks = [
        "file:///mnt/Media"
        "file:///mnt/Archive"
      ];
    }
  ];
}
