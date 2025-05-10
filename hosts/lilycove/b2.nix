{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.rclone];

  fileSystems = let
    backblazeDirectory = "/mnt/Backblaze";
    dataDirectory = "/mnt/Data";

    b2Options = [
      "allow_other"
      "args2env"
      "cache-dir=${dataDirectory}/.rclone-cache"
      "config=${config.age.secrets.rclone-b2.path}"
      "dir-cache-time=1h"
      "nodev"
      "nofail"
      "vfs-cache-mode=full"
      "vfs-write-back=10s"
      "x-systemd.after=network-online.target"
      "x-systemd.automount"
    ];

    b2ProfileOptions = {
      audio = [
        "buffer-size=128M"
        "vfs-cache-max-age=168h"
        "vfs-cache-max-size=10G"
        "vfs-read-ahead=3G"
      ];

      video = [
        "buffer-size=512M"
        "vfs-cache-max-age=336h"
        "vfs-cache-max-size=200G"
        "vfs-read-ahead=5G"
      ];
    };

    mkB2Mount = name: remote: profile: {
      "${backblazeDirectory}/${name}" = {
        device = "b2:${remote}";
        fsType = "rclone";
        options = b2Options ++ b2ProfileOptions.${profile};
      };
    };
  in
    mkB2Mount "Anime" "aly-anime" "video"
    // mkB2Mount "Audiobooks" "aly-audiobooks" "audio"
    // mkB2Mount "Movies" "aly-movies" "video"
    // mkB2Mount "Shows" "aly-shows" "video";
}
