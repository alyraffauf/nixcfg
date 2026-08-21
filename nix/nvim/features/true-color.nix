# Request 24-bit terminal colors for themes and highlights.
_: {
  flake.neovimModules.default = {
    config.vim.options.termguicolors = true;
  };
}
