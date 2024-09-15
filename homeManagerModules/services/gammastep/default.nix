{
  config,
  lib,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.gammastep.enable {
    services.gammastep = {
      enable = true;
      latitude = lib.mkDefault "33.74";
      longitude = lib.mkDefault "-84.38";
    };

    systemd.user.services.gammastep = {
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target" ++ lib.optional (cfg.desktop.river.enable) "river-session.target");
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target" ++ lib.optional (cfg.desktop.sway.enable) "sway-session.target" ++ lib.optional (cfg.desktop.river.enable) "river-session.target";
    };
  };
}
