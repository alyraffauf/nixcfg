# Wrap long display lines without changing file contents.
_: {
  flake.neovimModules.default = {
    config.vim.options = {
      breakindent = true;
      wrap = true;
    };
  };
}
