{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.services.pipewire-inhibit.enable = lib.mkEnableOption "Inhibit idle when audio is playing with Pipewire.";

  config = lib.mkIf cfg.services.pipewire-inhibit.enable {
    systemd.user.services.pipewire-inhibit-idle = {
      Unit = {
        After = "graphical-session.target";
        BindsTo = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target";
        Description = "inhibit idle when audio is playing with Pipewire.";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = lib.getExe pkgs.wayland-pipewire-idle-inhibit;
        Restart = "no";
      };

      Install.WantedBy = lib.optional (cfg.desktop.hyprland.enable) "hyprland-session.target";
    };
  };
}
