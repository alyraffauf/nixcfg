# Render color literals with their actual colors.
_: {
  flake.neovimModules.default = {
    config.vim.ui.colorizer.enable = true;
  };
}
