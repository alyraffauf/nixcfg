# Open horizontal splits below and vertical splits to the right.
_: {
  flake.neovimModules.default = {
    config.vim.options = {
      splitbelow = true;
      splitright = true;
    };
  };
}
