{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  config = lib.mkIf cfg.apps.swaylock.enable {
    home.packages = with pkgs; [swaylock];

    programs.swaylock = {
      enable = true;
      settings = {
        daemonize = true;
        indicator-thickness = 20;
        indicator-radius = 120;
        indicator-idle-visible = true;
        indicator-caps-lock = true;
      };
    };
  };
}
