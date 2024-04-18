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
    ./firefox
    ./fractal
    ./fuzzel
    ./fzf
    ./google-chrome
    ./kanshi
    ./librewolf
    ./mako
    ./neofetch
    ./neovim
    ./obsidian
    ./tauon
    ./thunderbird
    ./tmux
    ./vsCodium
    ./waybar
    ./webCord
    ./wlogout
    ./zoom
  ];

  home.packages = with pkgs; [
    # backblaze-b2
    browsh
    curl
    gh
    git
    python3
    ruby
    wget
  ];

  programs.nnn.enable = lib.mkDefault true;

  programs.rbw.enable = lib.mkDefault true;

  alyraffauf.apps.bash.enable = lib.mkDefault true;
  alyraffauf.apps.emacs.enable = lib.mkDefault true;
  alyraffauf.apps.eza.enable = lib.mkDefault true;
  alyraffauf.apps.fzf.enable = lib.mkDefault true;
  alyraffauf.apps.neofetch.enable = lib.mkDefault true;
  alyraffauf.apps.neovim.enable = lib.mkDefault true;
  alyraffauf.apps.tmux.enable = lib.mkDefault true;

  alyraffauf.apps.alacritty.enable = lib.mkDefault true;
  alyraffauf.apps.chromium.enable = lib.mkDefault false;
  alyraffauf.apps.firefox.enable = lib.mkDefault true;
  alyraffauf.apps.fractal.enable = lib.mkDefault true;
  alyraffauf.apps.google-chrome.enable = lib.mkDefault true;
  alyraffauf.apps.obsidian.enable = lib.mkDefault true;
  alyraffauf.apps.tauon.enable = lib.mkDefault true;
  alyraffauf.apps.thunderbird.enable = lib.mkDefault true;
  alyraffauf.apps.vsCodium.enable = lib.mkDefault true;
  alyraffauf.apps.webCord.enable = lib.mkDefault true;
  alyraffauf.apps.zoom.enable = lib.mkDefault true;
}
