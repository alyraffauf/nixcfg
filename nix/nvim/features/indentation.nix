# Use spaces and two-column indentation as the editor default.
_: {
  flake.neovimModules.default = {
    config.vim.options = {
      autoindent = true;
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      softtabstop = 2;
      tabstop = 2;
    };
  };
}
