{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        wayland.windowManager.sway.config.output = {
          "eDP-2" = {
            adaptive_sync = "on";
            scale = "1.25";
          };
        };

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
