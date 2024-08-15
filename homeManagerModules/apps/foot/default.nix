{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.apps.foot.enable {
    programs.foot = {
      enable = true;
    };
  };
}
