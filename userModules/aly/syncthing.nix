{
  config,
  lib,
  ...
}: let
  cfg = config.ar.users.aly.syncthing;
  devices = import ../../syncthing/devices.nix;

  folders = lib.mkMerge [
    (import ../../syncthing/folders.nix)
    {
      "music" = {
        enable = cfg.syncMusic;
        path = cfg.musicPath;
      };

      "roms".enable = cfg.syncROMs;
    }
  ];
in {
  config = lib.mkIf cfg.enable {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services.syncthing = {
      enable = true;
      cert = cfg.certFile;
      configDir = "${config.services.syncthing.dataDir}/.syncthing";
      dataDir = "/home/aly";
      key = cfg.keyFile;
      openDefaultPorts = true;
      user = "aly";

      settings = {
        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          urAccepted = -1;
        };

        inherit devices folders;
      };
    };
  };
}
