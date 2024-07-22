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

  screenshot = pkgs.writeShellScript "screenshooter" ''
    FILENAME=${config.xdg.userDirs.pictures}/screenshots/$(date +'%Y-%m-%d-%H:%M:%S_grim.png')
    MAKO_MODE=$(${lib.getExe' pkgs.mako "makoctl"} mode)

    if echo "$MAKO_MODE" | grep -q "do-not-disturb"; then
      DND=true
    else
      DND=false
      ${lib.getExe' pkgs.mako "makoctl"} mode -t do-not-disturb
    fi

    ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -o)" "$FILENAME"

    if [ "$DND" = false ]; then
      ${lib.getExe' pkgs.mako "makoctl"} mode -t do-not-disturb
    fi

    if [ -e "$FILENAME" ]; then
      ${lib.getExe' pkgs.wl-clipboard-rs "wl-copy"} $FILENAME
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot saved" "$FILENAME" -i "$FILENAME"
    fi
  '';

  volume = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --output-volume=raise";
    down = "${bin} --output-volume=lower";
    mute = "${bin} --output-volume=mute-toggle";
    micMute = "${bin} --input-volume=mute-toggle";
  };
}
