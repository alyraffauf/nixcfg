{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        wayland.windowManager.sway.config.output = {
          "eDP-1" = {
            adaptive_sync = "on";
            scale = "2.0";
          };
        };

        ar.home.desktop.hyprland.laptopMonitors = ["eDP-1,1920x1200@165, 0x0, 2, vrr, 0"];
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
