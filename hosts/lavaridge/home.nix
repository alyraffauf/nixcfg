{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        ar.home = {
          desktop.hyprland.laptopMonitors = ["desc:BOE NE135A1M-NY1,2880x1920@60, 0x0, 2, vrr, 0"];

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
