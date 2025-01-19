{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.myHome.laptopMode {
    wayland.windowManager = {
      hyprland.settings = {
        windowrulev2 = [
          "workspace 1,class:(brave-browser)"
          "workspace 5,class:(firework)"
        ];

        workspace = [
          "1,defaultName:web,on-created-empty:${lib.getExe config.myHome.defaultApps.webBrowser}"
          "2,defaultName:note,on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}"
          "3,defaultName:code,on-created-empty:${lib.getExe config.myHome.defaultApps.editor}"
          "4,defaultName:mail,on-created-empty:${lib.getExe config.programs.thunderbird.package}"
          "special:magic,on-created-empty:${lib.getExe pkgs.fractal}"
        ];
      };
    };
  };
}
