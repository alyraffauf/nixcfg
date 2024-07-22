{lib, ...}: {
  home-manager.sharedModules = [
    {
      gtk.font.size = lib.mkForce 14;
      home.pointerCursor.size = lib.mkForce 24;
      wayland.windowManager.sway.config.output = {"LG Display 0x0569 Unknown".scale = "1.0";};

      ar.home = {
        desktop.hyprland.laptopMonitors = ["desc:LG Display 0x0569,preferred,auto,1.0"];

        services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer";
        };
      };
    }
  ];
}
