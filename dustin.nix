{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./homeManagerModules];
  home.username = "dustin";
  home.homeDirectory = "/home/dustin";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fractal
    libreoffice-fresh
    plexamp
    vlc
    zoom-us
  ];

  alyraffauf = {
    desktop.hyprland = {
      enable = true;
      hyprpaper.randomWallpaper = false;
    };
    apps = {
      alacritty.enable = true;
      bash.enable = true;
      chromium.enable = true;
      eza.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      vsCodium.enable = true;
      webCord.enable = true;
    };
  };
}
