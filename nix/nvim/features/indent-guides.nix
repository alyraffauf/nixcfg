# Draw indentation guides without changing buffer text.
_: {
  flake.neovimModules.default = {
    config.vim.visuals.blink-indent.enable = true;
  };
}
