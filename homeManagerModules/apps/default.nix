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
    ./eza
    ./fastfetch
    ./firefox
    ./fuzzel
    ./fzf
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
