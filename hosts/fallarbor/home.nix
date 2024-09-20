{
  home-manager.sharedModules = [
    {
      services.easyeffects = {
        enable = true;
        preset = "fw13-easy-effects";
      };

      wayland.windowManager.sway.config.output = {"BOE 0x095F Unknown".scale = "1.5";};
      ar.home.desktop.hyprland.laptopMonitors = ["desc:BOE 0x095F,preferred,auto,1.566667"];
    }
  ];
}
