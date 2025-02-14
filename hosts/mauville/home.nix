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
        self.homeManagerModules.default
        self.inputs.agenix.homeManagerModules.default
      ];

      age.secrets.rclone-b2.file = ../../secrets/rclone/b2.age;

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          curl
          rclone
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
                  rclone
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

              # Recursively backup folders to B2 with sanity checks.
              for folder in "''${!backups[@]}"; do
                if [ -d "$folder" ] && [ "$(ls -A "$folder")" ]; then
                  rclone --config=${config.age.secrets.rclone-b2.path} \
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

      myHome = {
        profiles.shell.enable = true;
        programs.fastfetch.enable = true;
      };
    }
  );
}
