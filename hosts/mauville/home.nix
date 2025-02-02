{
  lib,
  self,
  ...
}: {
  home-manager.users.aly = lib.mkForce (
    {
      config,
      pkgs,
      ...
    }: {
      imports = [
        self.homeManagerModules.profiles-shell
        self.homeManagerModules.programs-fastfetch
        self.homeManagerModules.programs-yazi
        self.inputs.agenix.homeManagerModules.default
      ];

      age.secrets = {
        backblazeKeyId.file = ../../secrets/aly/backblaze/keyId.age;
        backblazeKey.file = ../../secrets/aly/backblaze/key.age;
      };

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          curl
        ];

        stateVersion = "25.05";
        username = "aly";
      };

      programs = {
        helix = {
          enable = true;
          defaultEditor = true;
        };

        home-manager.enable = true;
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
    }
  );
}
