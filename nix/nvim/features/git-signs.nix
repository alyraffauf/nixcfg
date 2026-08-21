# Mark changed lines and expose buffer-local Git actions.
_: {
  flake.neovimModules.default = {
    config.vim.git = {
      enable = true;
      gitsigns = {
        enable = true;
        codeActions.enable = false;
      };
    };
  };
}
