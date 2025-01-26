{
  lib,
  pkgs,
  ...
}: {
  imports = [./laptop.nix];

  wayland.windowManager = {
    hyprland.settings = {
      bind = [
        "SUPER,N,exec,${lib.getExe' pkgs.obsidian "obsidian"}"
        "SUPER,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"
      ];

      input.kb_options = "ctrl:nocaps";

      windowrulev2 = [
        # "bordersize 0,floating:0,onworkspace:f[1]"
        # "bordersize 0,floating:0,onworkspace:w[tv1]"
        "center(1),class:(Bitwarden)"
        "center(1),class:(org.keepassxc.KeePassXC)"
        "float,class:(Bitwarden)"
        "float,class:(org.keepassxc.KeePassXC)"
        # "rounding 0,floating:0,onworkspace:f[1]"
        # "rounding 0,floating:0,onworkspace:w[tv1]"
        "size 80% 80%,class:(Bitwarden)"
        "size 80% 80%,class:(org.keepassxc.KeePassXC)"
        "workspace special:magic,class:(org.gnome.Fractal)"
        "workspace special:magic,class:(vesktop)"
      ];

      workspace = [
        # "f[1],gapsout:0,gapsin:0"
        "special:magic,on-created-empty:${lib.getExe pkgs.fractal}"
        # "w[tv1],gapsout:0,gapsin:0"
      ];
    };
  };

  myHome.desktop.hyprland.monitors = [
    "desc:Guangxi Century Innovation Display Electronics Co. Ltd 27C1U-D 0000000000001,preferred,-1920x0,2.0"
    "desc:HP Inc. HP 24mh 3CM037248S,preferred,-1920x0,auto"
    "desc:LG Electronics LG IPS QHD 109NTWG4Y865,preferred,-2560x0,auto"
  ];
}
