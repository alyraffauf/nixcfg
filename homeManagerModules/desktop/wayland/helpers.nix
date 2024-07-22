{
  config,
  lib,
  pkgs,
  ...
}: {
  brightness = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --brightness=raise";
    down = "${bin} --brightness=lower";
  };

  media = rec {
    bin = lib.getExe pkgs.playerctl;
    play = "${bin} play-pause";
    paus = "${bin} pause";
    next = "${bin} next";
    prev = "${bin} previous";
  };

  screenshot = rec {
    bin = pkgs.writeShellScript "screenshooter" ''
      FILENAME=${config.xdg.userDirs.pictures}/screenshots/$(date +'%Y-%m-%d-%H:%M_grim.png')

      if [ "$1" == "region" ]; then
        ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" "$FILENAME"
      elif [ "$1" == "screen" ]; then
        ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -o)" "$FILENAME"
      else
          exit 1
      fi

      ${lib.getExe' pkgs.wl-clipboard-rs "wl-copy"} $FILENAME
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot saved" "$FILENAME" -i "$FILENAME"
    '';

    region = "${bin} region";
    screen = "${bin} screen";
  };

  volume = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --output-volume=raise";
    down = "${bin} --output-volume=lower";
    mute = "${bin} --output-volume=mute-toggle";
    micMute = "${bin} --input-volume=mute-toggle";
  };
}
