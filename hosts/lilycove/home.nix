{
  lib,
  self,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        gtk.gtk3.bookmarks = [
          "file:///mnt/Archive"
        ];

        wayland.windowManager.hyprland.settings = {
          general.layout = lib.mkForce "master";

          master = {
            mfact = 0.40;
            orientation = "center";
          };
        };

        ar.home = {
          desktop = {
            autoSuspend = false;
            hyprland.monitors = ["desc:LG Electronics LG ULTRAWIDE 311NTAB5M720,preferred,auto,1.0,vrr,2"];
          };

          services = {
            easyeffects = {
              enable = true;
              preset = "LoudnessEqualizer";
            };
          };
        };
      }
    ];

    users = {
      aly = self.homeManagerModules.aly;
      # dustin = self.homeManagerModules.dustin;
    };
  };
}
