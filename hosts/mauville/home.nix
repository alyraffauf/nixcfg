{
  lib,
  pkgs,
  self,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        gtk.gtk3.bookmarks = [
          "file:///mnt/Media"
          "file:///mnt/Archive"
        ];

        xdg.userDirs.music = "/mnt/Media/Music";

        ar.home = {
          desktop = {
            autoSuspend = false;
            hyprland.monitors = ["desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.0,vrr,2"];
          };

          services = {
            easyeffects = {
              enable = true;
              preset = "LoudnessEqualizer";
            };

            gammastep.enable = lib.mkForce false;
          };
        };
      }
    ];

    users = {
      aly = {config, ...}: {
        imports = [self.homeManagerModules.aly];

        age.secrets = {
          backblazeKeyId.file = ../../secrets/aly/backblaze/keyId.age;
          backblazeKey.file = ../../secrets/aly/backblaze/key.age;
        };

        systemd.user = {
          services.backblaze-sync = {
            Unit.Description = "Backup to Backblaze.";

            Service = {
              Environment = [
                "PATH=${
                  lib.makeBinPath (with pkgs; [
                    coreutils
                    backblaze-b2
                  ])
                }"
              ];

              ExecStart = "${pkgs.writeShellScript "backblaze-sync" ''
                declare -A backups
                backups=(
                  ['/home/aly/sync']="b2://aly-sync"
                  ['/mnt/Archive/Movies']="b2://aly-movies"
                  ['/mnt/Archive/Shows']="b2://aly-shows"
                  ['/mnt/Media/Audiobooks']="b2://aly-audiobooks"
                  ['/mnt/Media/Music']="b2://aly-music"
                  ['/mnt/Media/Pictures']="b2://aly-pictures"
                )

                backblaze-b2 authorize_account `cat ${config.age.secrets.backblazeKeyId.path}` `cat ${config.age.secrets.backblazeKey.path}`

                # Recursively backup folders to B2 with sanity checks.
                for folder in "''${!backups[@]}"; do
                  if [ -d "$folder" ] && [ "$(ls -A "$folder")" ]; then
                    backblaze-b2 sync --delete $folder ''${backups[$folder]}
                  else
                    echo "$folder does not exist or is empty."
                    exit 1
                  fi
                done
              ''}";
            };
          };

          timers.backblaze-sync = {
            Install.WantedBy = ["timers.target"];
            Timer.OnCalendar = "*-*-* 03:00:00";
            Unit.Description = "Daily backups to Backblaze.";
          };
        };

        wayland.windowManager.hyprland.settings = {
          general.layout = lib.mkForce "master";

          master = {
            mfact = 0.40;
            orientation = "center";
          };
        };
      };

      # dustin = self.homeManagerModules.dustin;
    };
  };
}
