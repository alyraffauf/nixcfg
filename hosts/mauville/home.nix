{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        imports = [../../homeManagerModules];
        xdg.userDirs.music = "/mnt/Media/Music";
        alyraffauf.desktop.hyprland.autoSuspend = false;
        alyraffauf.desktop.sway.autoSuspend = false;
      }
    ];
    users.aly = {
      imports = [../../aly.nix];
      systemd.user.services.backblaze-sync = {
        Unit = {
          Description = "Push Syncthing folers to Backblaze.";
        };
        Install = {
          WantedBy = ["default.target"];
        };
        Service = {
          ExecStart = "${pkgs.writeShellScript "backblaze-sync" ''
          #!/run/current-system/sw/bin/bash

          BACKBLAZE=${lib.getExe pkgs.backblaze-b2}

          $BACKBLAZE sync --delete /mnt/Media/Music b2://aly-music
          $BACKBLAZE sync --delete /mnt/Media/Audiobooks b2://aly-audiobooks
          $BACKBLAZE sync --delete /mnt/Archive/Archive b2://aly-archive

          $BACKBLAZE sync --delete /home/aly/sync b2://aly-sync
          ''}";
        };
      };
    };
    users.dustin = import ../../dustin.nix;
  };
}
