{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        myHome = {
          desktop.hyprland.laptopMonitors = ["desc:BOE NE135A1M-NY1,2880x1920@60, 0x0, 2, vrr, 0"];
          laptopMode = true;
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
