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
      settings = import ./settings.nix {inherit config lib pkgs;};

      extraConfig = let
        moveMonitorBinds =
          lib.attrsets.mapAttrsToList (
            key: direction: "bind=CONTROL,${key},movecurrentworkspacetomonitor,${builtins.substring 0 1 direction}"
          )
          cfg.desktop.windowManagerBinds;

        moveWindowBinds =
          lib.attrsets.mapAttrsToList (
            key: direction: "bind=,${key},movewindow,${builtins.substring 0 1 direction}"
          )
          cfg.desktop.windowManagerBinds;

        moveWorkspaceBinds = builtins.map (x: "bind=,${toString x},workspace,${toString x}") [1 2 3 4 5 6 7 8 9];
      in ''
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
        ${lib.strings.concatLines moveMonitorBinds}
        ${lib.strings.concatLines moveWindowBinds}
        ${lib.strings.concatLines moveWorkspaceBinds}
        bind=,comma,exec,${lib.getExe pkgs.hyprnome} --previous --move
        bind=,period,exec,${lib.getExe pkgs.hyprnome} --move
        bind=,escape,submap,reset
        submap=reset
      '';
    };
  };
}
