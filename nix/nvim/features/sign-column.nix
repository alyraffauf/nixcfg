# Reserve the sign column so diagnostics do not shift text.
_: {
  flake.neovimModules.default = {
    config.vim.options.signcolumn = "yes";
  };
}
