# Highlight text affected by undo and redo operations.
_: {
  flake.neovimModules.default = {
    config.vim.visuals.highlight-undo.enable = true;
  };
}
