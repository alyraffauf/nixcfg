{
  home-manager.sharedModules = [
    {
      wayland.windowManager.sway.config.output = {"LG Display 0x0569 Unknown".scale = "1.0";};

      ar.home = {
        desktop.hyprland.laptopMonitors = ["desc:LG Display 0x0569,preferred,auto,1.0"];

        services.easyeffects = {
          enable = true;
          preset = "LoudnessEqualizer";
        };

        theme = {
          monospaceFont.size = 14;
          sansFont.size = 14;
          serifFont.size = 14;
        };
      };
    }
  ];
}
