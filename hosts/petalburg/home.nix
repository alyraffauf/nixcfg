{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        myHome.desktop.hyprland.laptopMonitors = ["desc:Lenovo Group Limited 0x8BA1 0x00006003,3200x2000@165, 0x0, 2, vrr, 1"];
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
