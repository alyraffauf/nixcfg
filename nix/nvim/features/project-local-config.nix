# Allow trusted project-local configuration under Neovim's secure rules.
_: {
  flake.neovimModules.default = {
    config.vim.options = {
      exrc = true;
      secure = true;
    };
  };
}
