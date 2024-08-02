{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.services.pipewire-inhibit.enable {
    systemd.user.services.pipewire-inhibit-idle = {
      Unit = {
        After = "graphical-session.target";
        Description = "inhibit idle when audio is playing with Pipewire.";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = lib.getExe pkgs.wayland-pipewire-idle-inhibit;
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install.WantedBy = ["hyprland-session.target" "sway-session.target"];
    };
  };
}
