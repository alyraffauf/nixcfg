{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.user.services = {
    icloud = let
      mountdir = "${config.home.homeDirectory}/icloud";
    in {
      Unit = {
        Description = "Mount iCloud Drive";
        After = ["network-online.target"];
      };

      Service = {
        Type = "notify";
        Environment = ["PATH=/run/wrappers/bin/:$PATH"];
        ExecStartPre = "${lib.getExe' pkgs.uutils-coreutils-noprefix "mkdir"} -p ${mountdir}";

        ExecStart = ''
          ${lib.getExe pkgs.rclone} mount icloud: ${mountdir} \
              --config=${config.age.secrets.rclone-icloud.path} \
              --dir-cache-time 48h \
              --vfs-cache-mode full \
              --vfs-cache-max-age 48h \
              --vfs-read-chunk-size 10M \
              --vfs-read-chunk-size-limit 512M \
              --no-modtime \
              --buffer-size 512M
        '';

        ExecStop = "${lib.getExe' pkgs.fuse "fusermount"} -u ${mountdir}";
        Restart = "always";
        RestartSec = 5;
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
