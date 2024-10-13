{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        wayland.windowManager = {
          hyprland.settings = {
            input = {
              touchdevice.output = "eDP-1";
            };
          };
        };

        ar.home = {
          desktop.hyprland.laptopMonitors = ["eDP-1, 1600x2560@144, 0x0, 2, transform, 1"];

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
