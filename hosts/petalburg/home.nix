{
  lib,
  pkgs,
  self,
  ...
}: {
  home-manager.sharedModules = [
    {
      wayland.windowManager = {
        hyprland.settings = {
          bind = [
            ",xf86launch2,exec,${lib.getExe pkgs.playerctl} play-pause"
            ",xf86launch4,exec,${lib.getExe self.inputs.pp-adjuster.packages.${pkgs.system}.default}"
          ];

          exec-once = [''${
              lib.getExe self.inputs.iio-hyprland.packages.${pkgs.system}.default
            } "desc:Samsung Display Corp. 0x4152"''];

          input = {
            tablet.output = "eDP-1";
            touchdevice.output = "eDP-1";
          };
        };

        sway.config = {
          input = {
            "1386:21186:Wacom_HID_52C2_Finger" = {
              map_to_output = "'Samsung Display Corp. 0x4152 Unknown'";
            };

            "1386:21186:Wacom_HID_52C2_Pen" = {
              map_to_output = "'Samsung Display Corp. 0x4152 Unknown'";
            };
          };

          keybindings = {
            "XF86Launch2" = "exec ${lib.getExe pkgs.playerctl} play-pause";
            "XF86Launch4" = "exec ${lib.getExe self.inputs.pp-adjuster.packages.${pkgs.system}.default}";
          };

          output = {"Samsung Display Corp. 0x4152 Unknown".scale = "2.0";};
        };
      };

      ar.home.desktop.hyprland = {
        laptopMonitors = ["desc:Samsung Display Corp. 0x4152,preferred,auto,2,transform,0"];

        tabletMode = {
          enable = true;
          tabletSwitches = ["Lenovo Yoga Tablet Mode Control switch"];
        };
      };
    }
  ];
}
