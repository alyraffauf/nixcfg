{
  config,
  lib,
  pkgs,
  ...
}: let
  wallpaperD = pkgs.writers.writeRuby "randomWallpaperD" {} (builtins.readFile ./script.rb);
in {
  config = lib.mkIf config.ar.home.services.randomWallpaper.enable {
    services.hyprpaper.enable = lib.mkForce false;
    # stylix.targets.hyprpaper.enable = lib.mkForce false;
    wayland.windowManager.sway.config.output."*" = lib.mkForce {}; # Dirty. TODO: make more elegant.

    systemd.user.services.randomWallpaper = {
      Unit = {
        After = "graphical-session.target";
        BindsTo = lib.optional (config.ar.home.desktop.hyprland.enable) "hyprland-session.target";
        Description = "Lightweight swaybg-based random wallpaper daemon.";
        PartOf = "graphical-session.target";
      };

      Service = {
        Environment = [
          "PATH=${
            lib.makeBinPath [
              config.wayland.windowManager.hyprland.package
              config.wayland.windowManager.sway.package
              pkgs.procps
              pkgs.swaybg
            ]
          }"
        ];

        ExecStart = "${wallpaperD}";
        Restart = "no";
        TasksMax = "infinity";
      };

      Install.WantedBy = lib.optional (config.ar.home.desktop.hyprland.enable) "hyprland-session.target";
    };
  };
}
