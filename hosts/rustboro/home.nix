{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        ar.home = {
          desktop.hyprland.laptopMonitors = ["desc:LG Display 0x0569,preferred,auto,1.25"];
          laptopMode = true;
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
