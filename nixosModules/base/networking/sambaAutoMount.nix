{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.base.sambaAutoMount {
    fileSystems = {
      "/mnt/Archive" = {
        device = "//mauville/Archive";
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
      };

      "/mnt/Media" = {
        device = "//mauville/Media";
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
      };
    };
  };
}
