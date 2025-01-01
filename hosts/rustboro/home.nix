{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        ar.home = {
          desktop.hyprland.laptopMonitors = ["desc:LG Display 0x0569,preferred,auto,1.25"];

          laptopMode = true;

          services = {
            easyeffects = {
              enable = true;
              preset = "LoudnessEqualizer";
            };

            gammastep.enable = true;
          };
        };
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
