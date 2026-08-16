_: {
  flake.nixosModules.aly = {pkgs, ...}: {
    users.users.aly.packages = with pkgs; [
      age 
      atuin
      bun 
      codex
      duf
      dust
      eza
      fd
      fzf
      gh
      go
      htop
      imagemagick
      jq
      just
      lazygit
      neovim
      nodejs
      opencode
      ripgrep
      ripgrep-all 
      starship
      tmux
      uv
      yq
      zoxide
    ];
  };
}
