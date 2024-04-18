{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./homeManagerModules];
  home.username = "aly";
  home.homeDirectory = "/home/aly";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    browsh
    curl
    fractal
    gh
    git
    google-chrome
    obsidian
    python3
    ruby
    wget
    zoom-us
  ];

  alyraffauf = {
    services.syncthing.enable = true;
    desktop.hyprland = {
      enable = true;
      hyprpaper.randomWallpaper.enable = true;
    };
    apps = {
      alacritty.enable = true;
      firefox.enable = true;
      bash.enable = true;
      emacs.enable = true;
      eza.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      chromium.enable = false;
      tauon.enable = true;
      thunderbird.enable = true;
      vsCodium.enable = true;
      webCord.enable = true;
    };
  };
}
