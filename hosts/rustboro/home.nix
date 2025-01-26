{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        myHome.desktop.hyprland.laptopMonitors = ["desc:LG Display 0x0569,preferred,auto,1.0"];
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
