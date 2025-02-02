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

        services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer.json";
        };

        wayland.windowManager.hyprland.settings = {
          general.layout = lib.mkForce "master";

          master = {
            mfact = 0.40;
            orientation = "center";
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
