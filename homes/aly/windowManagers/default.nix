{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./laptop.nix];

  programs.waybar.settings.mainBar."bluetooth" = {
    "on-click" = lib.mkForce "${lib.getExe pkgs.rofi-bluetooth} -i";
  };

  wayland.windowManager = {
    sway.config = {
      floating.criteria = [{app_id = "Bitwarden";} {app_id = "org.keepassxc.KeePassXC";}];

      gaps = {
        smartBorders = "on";
        smartGaps = true;
      };

      input."type:keyboard".xkb_options = "caps:ctrl_modifier";

      keybindings = {
        "${config.wayland.windowManager.sway.config.modifier}+N" = "exec ${lib.getExe' pkgs.obsidian "obsidian"}";
        "${config.wayland.windowManager.sway.config.modifier}+P" = "exec ${lib.getExe pkgs.rofi-rbw-wayland}";
      };

      startup = [
        {command = lib.getExe config.ar.home.defaultApps.editor;}
        {command = lib.getExe config.ar.home.defaultApps.webBrowser;}
        {command = lib.getExe pkgs.fractal;}
        {command = lib.getExe config.programs.thunderbird.package;}
        {command = lib.getExe' pkgs.obsidian "obsidian";}
      ];

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
        {
          command = "move to scratchpad";
          criteria = {app_id = "org.gnome.Fractal";};
        }
        {
          command = "move to scratchpad";
          criteria = {app_id = "vesktop";};
        }
      ];
    };

    hyprland.settings = {
      bind = [
        "SUPER,N,exec,${lib.getExe' pkgs.obsidian "obsidian"}"
        "SUPER,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"
      ];

      input.kb_options = "ctrl:nocaps";

      windowrulev2 = [
        "bordersize 0,floating:0,onworkspace:f[1]"
        "bordersize 0,floating:0,onworkspace:w[tv1]"
        "center(1),class:(Bitwarden)"
        "center(1),class:(org.keepassxc.KeePassXC)"
        "float,class:(Bitwarden)"
        "float,class:(org.keepassxc.KeePassXC)"
        "rounding 0,floating:0,onworkspace:f[1]"
        "rounding 0,floating:0,onworkspace:w[tv1]"
        "size 80% 80%,class:(Bitwarden)"
        "size 80% 80%,class:(org.keepassxc.KeePassXC)"
        "workspace special:magic,class:(org.gnome.Fractal)"
        "workspace special:magic,class:(vesktop)"
      ];

      workspace = [
        "f[1],gapsout:0,gapsin:0"
        "special:magic,on-created-empty:${lib.getExe pkgs.fractal}"
        "w[tv1],gapsout:0,gapsin:0"
      ];
    };
  };

  ar.home.desktop.hyprland.monitors = [
    "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-2400x0,1.6"
    "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
    "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
  ];
}
