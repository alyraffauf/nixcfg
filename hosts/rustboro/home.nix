{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        wayland.windowManager.sway.config.output = {"LG Display 0x0569 Unknown".scale = "1.25";};

        ar.home = {
          desktop.hyprland.laptopMonitors = ["desc:LG Display 0x0569,preferred,auto,1.25"];

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
