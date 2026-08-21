# Report language-server progress without blocking the editor.
_: {
  flake.neovimModules.default = {
    config.vim.visuals.fidget-nvim.enable = true;
  };
}
