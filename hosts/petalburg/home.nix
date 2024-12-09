{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        ar.home = {
          desktop.hyprland.laptopMonitors = ["desc:China Star Optoelectronics Technology Co. Ltd MNG007QA1-1,1920x1200@165, 0x0, 1.25, vrr, 1"];

          services.easyeffects = {
            enable = true;
            preset = "LoudnessEqualizer";
          };
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
