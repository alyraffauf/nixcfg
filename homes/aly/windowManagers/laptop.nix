{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.laptopMode {
    wayland.windowManager = {
      hyprland.settings = {
        exec-once = [
          "sleep 2 && hyprctl dispatch workspace 2 && sleep 2 && hyprctl dispatch workspace 3 && sleep 2 && hyprctl dispatch workspace 4 && sleep 2 && hyprctl dispatch workspace 1;"
        ];

        windowrulev2 = [
          "workspace 1,class:(brave-browser)"
          "workspace 5,class:(firework)"
        ];

        workspace = [
          "1,defaultName:web,on-created-empty:${lib.getExe config.ar.home.defaultApps.webBrowser}"
          "2,defaultName:note,on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}"
          "3,defaultName:code,on-created-empty:${lib.getExe config.ar.home.defaultApps.editor}"
          "4,defaultName:mail,on-created-empty:${lib.getExe config.programs.thunderbird.package}"
          "special:magic,on-created-empty:${lib.getExe pkgs.fractal}"
        ];
      };
    };
  };
}
