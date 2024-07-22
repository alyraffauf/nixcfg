{
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

  screenshot = {
    region = pkgs.writeShellScript "screenshot-region" ''
      FILENAME=$HOME/pics/screenshots/$(date +'%Y-%m-%d-%H:%M_grim.png')
      
      ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" "$FILENAME"
      ${lib.getExe' pkgs.wl-clipboard-rs "wl-copy"} $FILENAME
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot saved" "$FILENAME" -i "$FILENAME"
    '';

    screen = pkgs.writeShellScript "screenshot-screen" ''
      FILENAME=$HOME/pics/screenshots/$(date +'%Y-%m-%d-%H:%M_grim.png')
      
      ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -o)" "$FILENAME"
      ${lib.getExe' pkgs.wl-clipboard-rs "wl-copy"} $FILENAME
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot saved" "$FILENAME" -i "$FILENAME"
    '';
  };

  volume = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --output-volume=raise";
    down = "${bin} --output-volume=lower";
    mute = "${bin} --output-volume=mute-toggle";
    micMute = "${bin} --input-volume=mute-toggle";
  };
}
