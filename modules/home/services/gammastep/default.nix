{
  config,
  lib,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.services.gammastep.enable = lib.mkEnableOption "Gammastep redshift daemon.";

  config = lib.mkIf cfg.services.gammastep.enable {
    services.gammastep = {
      enable = true;
      latitude = lib.mkDefault "33.74";
      longitude = lib.mkDefault "-84.38";
    };

    systemd.user.services.gammastep = {
      Install.WantedBy = lib.mkForce (lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target");
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target";
    };
  };
}
