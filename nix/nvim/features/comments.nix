# Add operator-friendly line and block commenting.
_: {
  flake.neovimModules.default = {
    config.vim.comments.comment-nvim.enable = true;
  };
}
