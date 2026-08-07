{
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

  screenshot = pkgs.writeShellApplication {
    name = "screenshooter";

    runtimeInputs = with pkgs; [
      gnugrep
      grim
      libnotify
      mako
      slurp
      uutils-coreutils-noprefix
      wl-clipboard-rs
    ];

    text = builtins.readFile ./screenshooter.sh;
  };

  volume = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --output-volume=raise || ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
    down = "${bin} --output-volume=lower || ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    mute = "${bin} --output-volume=mute-toggle || ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
    micMute = "${bin} --input-volume=mute-toggle || ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
  };
}
