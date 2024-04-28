{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.swaylock.enable = lib.mkEnableOption "Enable Swaylock.";};

  config = lib.mkIf config.alyraffauf.apps.swaylock.enable {
    home.packages = with pkgs; [swaylock];

    xdg.configFile."swaylock/config".text = ''
      font="NotoSansMNerdFont-Regular"

      color=303446
      image=${config.xdg.dataHome}/backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg

      daemonize

      indicator-radius=120
      indicator-thickness=20
      indicator-caps-lock
      indicator-idle-visible

      key-hl-color=a6d189

      separator-color=232634cc

      inside-color=303446cc
      inside-clear-color=303446cc
      inside-caps-lock-color=303446cc
      inside-ver-color=303446cc
      inside-wrong-color=303446cc

      ring-color=ca9ee6cc
      ring-clear-color=85c1dccc
      ring-caps-lock-color=e78284cc
      ring-ver-color=a6d189cc
      ring-wrong-color=e78284cc

      line-color=232634cc
      line-clear-color=232634cc
      line-caps-lock-color=232634cc
      line-ver-color=232634cc
      line-wrong-color=232634cc

      text-clear-color=c6d0f5
      text-ver-color=c6d0f5
      text-wrong-color=c6d0f5

      bs-hl-color=e78284
      caps-lock-key-hl-color=e78284
      caps-lock-bs-hl-color=e78284
      text-caps-lock-color=c6d0f5
    '';
  };
}
