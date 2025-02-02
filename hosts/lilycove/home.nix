{
  lib,
  self,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        imports = [self.homeManagerModules.services-easyeffects];

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

        myHome.services = {
          easyeffects.preset = "LoudnessEqualizer";
          # hypridle.autoSuspend = false;
        };
      }
    ];

    users = {
      aly = self.homeManagerModules.aly;
      # dustin = self.homeManagerModules.dustin;
    };
  };
}
