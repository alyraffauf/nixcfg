# Ignore case in searches unless the query contains uppercase letters.
_: {
  flake.neovimModules.default = {
    config.vim.options = {
      ignorecase = true;
      smartcase = true;
    };
  };
}
