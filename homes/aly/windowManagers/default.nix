{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager = {
    sway.config = {
      assigns = {
        "workspace 1: web" = [{app_id = "firefox";} {app_id = "brave-browser";}];
        "workspace 2: code" = [{app_id = "codium-url-handler";}];
        "workspace 3: chat" = [{app_id = "org.gnome.Fractal";} {app_id = "WebCord";}];
        "workspace 4: work" = [{app_id = "google-chrome";} {app_id = "chromium-browser";} {app_id = "firework";}];
        "workspace 10: zoom" = [{class = "zoom";} {app_id = "Zoom";}];
      };

      output = {
        "Guangxi Century Innovation Display Electronics Co., Ltd 27C1U-D 0000000000001" = {
          scale = "1.5";
          pos = "-2560 0";
        };

        "HP Inc. HP 24mh 3CM037248S   " = {
          scale = "1.0";
          pos = "-1920 0";
        };
      };

      startup = [
        {command = ''${lib.getExe' pkgs.keepassxc "keepassxc"}'';}
      ];
    };

    hyprland.settings = {
      bind = [
        "SUPER SHIFT,N,movetoworkspace,special:notes"
        "SUPER,N,togglespecialworkspace,notes"
        "SUPER,P,exec,${lib.getExe' pkgs.keepassxc "keepassxc"}"
      ];

      exec-once = ["sleep 1 && ${lib.getExe' pkgs.keepassxc "keepassxc"}"];

      windowrulev2 = [
        "center(1),class:(org.keepassxc.KeePassXC)"
        "float,class:(org.keepassxc.KeePassXC)"
        "size 80% 80%,class:(org.keepassxc.KeePassXC)"
        "workspace 1,class:(brave-browser)"
        "workspace 1,class:(firefox)"
        "workspace 2,class:(codium-url-handler)"
        "workspace 2,class:(dev.zed.Zed)"
        "workspace 3,class:(firework)"
        "workspace 3,class:(google-chrome)"
        "workspace special:magic,class:(WebCord)"
        "workspace special:magic,class:(org.gnome.Fractal)"
      ];

      workspace = [
        "1,defaultName:web,on-created-empty:${lib.getExe config.ar.home.defaultApps.webBrowser}"
        "2,defaultName:code,on-created-empty:${lib.getExe config.ar.home.defaultApps.editor}"
        "special:magic,on-created-empty:${lib.getExe pkgs.fractal}"
        "special:notes,on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}"
      ];
    };
  };

  ar.home.desktop.hyprland.monitors = [
    "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2400x0,1.6"
    "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
    "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
  ];
}
