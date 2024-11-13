{
  config,
  lib,
  pkgs,
  ...
}: {
  brightness = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --brightness=raise || ${lib.getExe pkgs.brightnessctl} s +10%";
    down = "${bin} --brightness=lower || ${lib.getExe pkgs.brightnessctl} s 10%-";
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
      ${lib.getExe' pkgs.wl-clipboard-rs "wl-copy"} -t image/png < $FILENAME
      ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot saved" "$FILENAME" -i "$FILENAME"
    fi
  '';

  volume = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --output-volume=raise || ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
    down = "${bin} --output-volume=lower || ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    mute = "${bin} --output-volume=mute-toggle || ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
    micMute = "${bin} --input-volume=mute-toggle || ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
  };
}
