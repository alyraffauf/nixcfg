# Route editor notifications through nvim-notify.
_: {
  flake.neovimModules.default = {
    config.vim.notify.nvim-notify.enable = true;
  };
}
