{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./bash ./emacs ./eza ./fzf ./neovim ./tmux ./neofetch];

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

  cliApps.bash.enable = lib.mkDefault true;
  cliApps.emacs.enable = lib.mkDefault true;
  cliApps.eza.enable = lib.mkDefault true;
  cliApps.fzf.enable = lib.mkDefault true;
  cliApps.neofetch.enable = lib.mkDefault true;
  cliApps.neovim.enable = lib.mkDefault true;
  cliApps.tmux.enable = lib.mkDefault true;
}
