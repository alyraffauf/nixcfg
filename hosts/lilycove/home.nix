{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        gtk.gtk3.bookmarks = [
          "file:///mnt/Files"
        ];

        services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer.json";
        };

        # wayland.windowManager.hyprland.settings = {
        #   general.layout = lib.mkForce "master";

        #   master = {
        #     mfact = 0.40;
        #     orientation = "center";
        #   };
        # };

        myHome.services = {
          gammastep.enable = true;
          hypridle.autoSuspend = false;
        };
      }
    ];

    users = {
      aly = self.homeManagerModules.aly-linux;
      # dustin = self.homeManagerModules.dustin;
    };
  };
}
