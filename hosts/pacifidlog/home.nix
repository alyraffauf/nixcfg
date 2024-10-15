{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        wayland.windowManager = {
          hyprland.settings = {
            input = {
              touchdevice = {
                transform = 1;
                output = "eDP-1";
              };
            };
          };
        };

        ar.home = {
          desktop.hyprland = {
            laptopMonitors = ["desc:Lenovo Group Limited Go Display 0x00888888, 1600x2560@144, 0x0, 2, transform, 1"];
            tabletMode.enable = true;
          };
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
