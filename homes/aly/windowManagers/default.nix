{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager = {
    hyprland.settings = {
      bind = [
        "SUPER,N,exec,${lib.getExe' pkgs.obsidian "obsidian"}"
        "SUPER,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"
      ];

      windowrulev2 = [
        # "bordersize 0,floating:0,onworkspace:f[1]"
        # "bordersize 0,floating:0,onworkspace:w[tv1]"
        # "rounding 0,floating:0,onworkspace:f[1]"
        # "rounding 0,floating:0,onworkspace:w[tv1]"
        "workspace special:magic,class:(org.gnome.Fractal)"
        "workspace special:magic,class:(vesktop)"
      ];

      workspace =
        [
          "special:magic,on-created-empty:${lib.getExe pkgs.fractal}"
          # "f[1],gapsout:0,gapsin:0"
          # "w[tv1],gapsout:0,gapsin:0"
        ]
        ++ lib.lists.optionals (config.myHome.desktop.hyprland.laptopMonitor != null) [
          "1,defaultName:web,on-created-empty:${lib.getExe config.myHome.profiles.defaultApps.webBrowser}"
          "2,defaultName:note,on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}"
          "3,defaultName:code,on-created-empty:${lib.getExe config.myHome.profiles.defaultApps.editor}"
          "4,defaultName:mail,on-created-empty:${lib.getExe config.programs.thunderbird.package}"
        ];
    };
  };
}
