{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        myHome.desktop.hyprland.laptopMonitor = "desc:BOE NE135A1M-NY1,2880x1920@60, 0x0, 2, vrr, 0";
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
