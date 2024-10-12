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
          desktop.hyprland.laptopMonitors = ["eDP-1,2560x1600@144, preferred,auto, 2, transform, 0"];

          # services = {
          #   easyeffects = {
          #     enable = true;
          #     preset = "fw13-easy-effects";
          #   };
          # };
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
