# Run each language module's selected linters after edits and writes.
_: {
  flake.neovimModules.default = {
    config.vim = {
      diagnostics.nvim-lint.enable = true;
      extraLuaFiles = [./config.lua];
    };
  };
}
