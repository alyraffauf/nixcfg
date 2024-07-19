{
  home-manager.sharedModules = [
    {
      ar.home = {
        desktop.hyprland.laptopMonitors = ["desc:BOE 0x095F,preferred,auto,1.566667"];

        services.easyeffects = {
          enable = true;
          preset = "framework13";
        };
      };
    }
  ];
}
