{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager = {
    hyprland.settings = {
      bind = [
        "$mod SHIFT,D,movetoworkspace,special:discord"
        "$mod,D,togglespecialworkspace,discord"
        "$mod,N,exec,${lib.getExe' pkgs.obsidian "obsidian"}"
        "$mod,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"
      ];

      windowrulev2 = [
        # "bordersize 0,floating:0,onworkspace:f[1]"
        # "bordersize 0,floating:0,onworkspace:w[tv1]"
        # "rounding 0,floating:0,onworkspace:f[1]"
        # "rounding 0,floating:0,onworkspace:w[tv1]"
        # "workspace special:magic,class:(org.gnome.Fractal)"
        "workspace special:discord,class:(vesktop)"
        "workspace special:magic,class:(signal)"
      ];

      workspace = [
        "1,defaultName:web,on-created-empty:${config.myHome.profiles.defaultApps.webBrowser.exec}"
        "2,defaultName:note,on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}"
        "3,defaultName:code,on-created-empty:${config.myHome.profiles.defaultApps.editor.exec}"
        "4,defaultName:mail,on-created-empty:${lib.getExe config.programs.thunderbird.package}"
        "5,defaultName:work,on-created-empty:${lib.getExe pkgs.google-chrome}"
        "special:discord,on-created-empty:${lib.getExe config.programs.vesktop.package}"
        "special:magic,on-created-empty:${lib.getExe pkgs.signal-desktop-bin}"
      ];
    };
  };
}
