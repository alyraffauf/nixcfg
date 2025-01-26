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
          "1,defaultName:web,on-created-empty:${lib.getExe config.myHome.defaultApps.webBrowser}"
          "2,defaultName:note,on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}"
          "3,defaultName:code,on-created-empty:${lib.getExe config.myHome.defaultApps.editor}"
          "4,defaultName:mail,on-created-empty:${lib.getExe config.programs.thunderbird.package}"
        ];
    };
  };

  myHome.desktop.hyprland.monitors = [
    "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-1920x0,2.0"
    "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
    "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
  ];
}
