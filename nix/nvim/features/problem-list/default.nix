# Show project diagnostics and quickfix entries in Trouble.
_: {
  flake.neovimModules.default = {
    config.vim = {
      lsp.trouble.enable = true;
      extraLuaFiles = [./config.lua];
    };
  };
}
