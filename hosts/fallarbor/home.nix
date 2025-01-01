{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        ar.home = {
          desktop.hyprland.laptopMonitors = ["desc:BOE 0x095F,preferred,auto,1.566667"];
          laptopMode = true;

          services = {
            easyeffects = {
              enable = true;
              preset = "fw13-easy-effects";
            };

            gammastep.enable = true;
          };
        };
      }
    ];

    users = {
      aly = self.homeManagerModules.aly;
      dustin = self.homeManagerModules.dustin;
    };
  };
}
