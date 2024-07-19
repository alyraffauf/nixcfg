{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  # Media/hardware commands
  brightness = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --brightness=raise";
    down = "${bin} --brightness=lower";
  };

  # Default apps
  defaultApps = {
    browser = lib.getExe cfg.defaultApps.webBrowser;
    editor = lib.getExe cfg.defaultApps.editor;
    fileManager = lib.getExe cfg.defaultApps.fileManager;
    launcher = lib.getExe pkgs.fuzzel;
    lock = lib.getExe pkgs.swaylock;
    logout = lib.getExe pkgs.wlogout;
    terminal = lib.getExe cfg.defaultApps.terminal;
    virtKeyboard = lib.getExe' pkgs.squeekboard "squeekboard";
  };

  defaultWorkspaces = [1 2 3 4 5 6 7 8 9];

  media = rec {
    bin = lib.getExe pkgs.playerctl;
    play = "${bin} play-pause";
    paus = "${bin} pause";
    next = "${bin} next";
    prev = "${bin} previous";
  };

  screenshot = rec {
    bin = lib.getExe pkgs.hyprshot;
    folder = "${config.xdg.userDirs.pictures}/screenshots";
    screen = "${bin} -m output -o ${folder}";
    region = "${bin} -m region -o ${folder}";
  };

  volume = rec {
    bin = lib.getExe' pkgs.swayosd "swayosd-client";
    up = "${bin} --output-volume=raise";
    down = "${bin} --output-volume=lower";
    mute = "${bin} --output-volume=mute-toggle";
    micMute = "${bin} --input-volume=mute-toggle";
  };

  windowManagerBinds = {
    down = "d";
    left = "l";
    right = "r";
    up = "u";
    h = "l";
    j = "d";
    k = "u";
    l = "r";
  };
}
