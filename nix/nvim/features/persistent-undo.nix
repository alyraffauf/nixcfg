# Store undo history across editor processes.
_: {
  flake.neovimModules.default = {
    config.vim.options.undofile = true;
  };
}
