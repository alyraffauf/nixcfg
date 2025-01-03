{config, ...}: {
  assertions = [
    {
      assertion = config.services.tailscale.enable;
      message = "Samba connects to mauville shares over tailscale, but services.tailscale.enable != true.";
    }
  ];

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
}
