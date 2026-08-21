# Keep the cursor's screen line visually distinct.
_: {
  flake.neovimModules.default = {
    config.vim.options.cursorline = true;
  };
}
