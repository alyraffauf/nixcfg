{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./bash
    ./chromium
    ./emacs
    ./fastfetch
    ./firefox
    ./fuzzel
    ./keepassxc
    ./librewolf
    ./mako
    ./nemo
    ./neofetch
    ./neovim
    ./swaylock
    ./thunar
    ./tmux
    ./vsCodium
    ./waybar
    ./wlogout
  ];
}
