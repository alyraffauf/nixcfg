{lib, ...}: {
  home-manager.sharedModules = [
    {
      wayland.windowManager.sway.config.output = {"BOE 0x095F Unknown".scale = "1.5";};

      ar.home = {
        desktop.hyprland.laptopMonitors = ["desc:BOE 0x095F,preferred,auto,1.566667"];

        services = {
          easyeffects = {
            enable = true;
            preset = "LoudnessEqualizer";
          };

          gammastep.enable = lib.mkForce false;
        };
      };
    }
  ];
}
