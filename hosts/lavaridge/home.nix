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

        ar.home = {
          desktop.hyprland.laptopMonitors = ["eDP-1,2880x1920@60, 0x0, 2, vrr, 0"];

          services = {
            easyeffects = {
              enable = true;
              preset = "fw13-autogain";
            };
          };
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
