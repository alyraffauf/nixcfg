# Insert and remove matching delimiters as a pair.
_: {
  flake.neovimModules.default = {
    config.vim.autopairs.nvim-autopairs.enable = true;
  };
}
