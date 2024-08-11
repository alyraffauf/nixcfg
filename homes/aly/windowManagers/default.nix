{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.waybar.settings.mainBar."bluetooth" = {
    "on-click" = lib.mkForce "${lib.getExe pkgs.rofi-bluetooth} -i";
  };

  wayland.windowManager = {
    sway.config = {
      assigns = {
        "workspace 1: web" = [{app_id = "firefox";} {app_id = "brave-browser";}];
        "workspace 2: code" = [{app_id = "codium-url-handler";} {app_id = "dev.zed.Zed";}];
        "workspace 3: note" = [{app_id = "obsidian";}];
        "workspace 4: chat" = [{app_id = "org.gnome.Fractal";} {app_id = "WebCord";}];
        "workspace 5: work" = [{app_id = "google-chrome";} {app_id = "chromium-browser";} {app_id = "firework";}];
      };

      floating.criteria = [{app_id = "Bitwarden";} {app_id = "org.keepassxc.KeePassXC";}];

      input."type:keyboard".xkb_options = "caps:ctrl_modifier";

      keybindings = {
        "${config.wayland.windowManager.sway.config.modifier}+P" = "exec ${lib.getExe pkgs.rofi-rbw-wayland}";
        "${config.wayland.windowManager.sway.config.modifier}+N" = "exec ${lib.getExe' pkgs.obsidian "obsidian"}";
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

      window.commands = [
        {
          command = "resize set 80ppt 80ppt; move position center;";
          criteria = {app_id = "Bitwarden";};
        }
        {
          command = "resize set 80ppt 80ppt; move position center; sticky toggle;";
          criteria = {app_id = "org.keepassxc.KeePassXC";};
        }
      ];
    };

    hyprland.settings = {
      bind = [
        "SUPER,N,exec,${lib.getExe' pkgs.obsidian "obsidian"}"
        "SUPER,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"
      ];

      dwindle.no_gaps_when_only = "1";

      exec-once = [
        "sleep 2 && hyprctl dispatch workspace 2 && sleep 2 && hyprctl dispatch workspace 3 && sleep 2 && hyprctl dispatch workspace 4 && sleep 2 && hyprctl dispatch workspace 1;"
      ];

      input.kb_options = "ctrl:nocaps";

      windowrulev2 = [
        "center(1),class:(Bitwarden)"
        "center(1),class:(org.keepassxc.KeePassXC)"
        "float,class:(Bitwarden)"
        "float,class:(org.keepassxc.KeePassXC)"
        "size 80% 80%,class:(Bitwarden)"
        "size 80% 80%,class:(org.keepassxc.KeePassXC)"
        "workspace 1,class:(brave-browser)"
        "workspace 5,class:(firework)"
        "workspace special:magic,class:(WebCord)"
        "workspace special:magic,class:(org.gnome.Fractal)"
        # "workspace 1,class:(firefox)"
        # "workspace 2,class:(obsidian)"
        # "workspace 3,class:(codium-url-handler)"
        # "workspace 3,class:(dev.zed.Zed)"
        # "workspace 4,class:(thunderbird)"
      ];

      workspace = [
        "1,defaultName:web,on-created-empty:${lib.getExe config.ar.home.defaultApps.webBrowser}"
        "2,defaultName:note,on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}"
        "3,defaultName:code,on-created-empty:${lib.getExe config.ar.home.defaultApps.editor}"
        "4,defaultName:mail,on-created-empty:${lib.getExe pkgs.thunderbird}"
        "special:magic,on-created-empty:${lib.getExe pkgs.fractal}"
      ];
    };
  };

  ar.home.desktop.hyprland.monitors = [
    "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2400x0,1.6"
    "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
    "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
  ];
}
