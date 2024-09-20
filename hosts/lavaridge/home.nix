{lib, ...}: {
  home-manager.sharedModules = [
    {
      wayland.windowManager.sway.config.output = {
        "eDP-1" = {
          adaptive_sync = "on";
          scale = "2.0";
        };
      };

      ar.home = {
        desktop.hyprland.laptopMonitors = ["eDP-1,2880x1920@120, 0x0, 2, vrr, 1"];

        services = {
          easyeffects = {
            enable = true;
            preset = "fw13-easy-effects";
          };

          gammastep.enable = lib.mkForce false;
        };

        theme.borders.radius = lib.mkForce 10;
      };
    }
  ];
}
