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
    ./librewolf
    ./mako
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
