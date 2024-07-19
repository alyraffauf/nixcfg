{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings =
        import ./vars.nix {inherit config lib pkgs;};

      extraConfig = ''
        submap=resize
        binde=,down,resizeactive,0 10
        binde=,left,resizeactive,-10 0
        binde=,right,resizeactive,10 0
        binde=,up,resizeactive,0 -10
        binde=,j,resizeactive,0 10
        binde=,h,resizeactive,-10 0
        binde=,l,resizeactive,10 0
        binde=,k,resizeactive,0 -10
        bind=,escape,submap,reset
        submap=reset

        submap=move
        # Move window with keys ++
        # Move workspaces across monitors with CONTROL + keys.
        ${
          lib.strings.concatLines
          (
            lib.attrsets.mapAttrsToList (key: direction: ''
              bind = , ${key}, movewindow, ${direction}
              bind = CONTROL, ${key}, movecurrentworkspacetomonitor, ${direction}
            '')
            cfg.desktop.hyprland.windowManagerBinds
          )
        }

        # Move active window to a workspace with [1-9]
        ${
          lib.strings.concatMapStringsSep "\n"
          (x: "bind = , ${toString x}, movetoworkspace, ${toString x}")
          cfg.desktop.hyprland.workspaces
        }

        # hyprnome
        bind = , comma, exec, ${lib.getExe pkgs.hyprnome} --previous --move
        bind = , period, exec, ${lib.getExe pkgs.hyprnome} --move
        bind=,escape,submap,reset
        submap=reset
      '';
    };
  };
}
