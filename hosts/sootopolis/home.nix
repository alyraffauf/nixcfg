{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        myHome.desktop.hyprland.laptopMonitor = "eDP-1,preferred,auto,1.20";
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
