# Create missing parent directories immediately before a file write.
_: {
  flake.neovimModules.default = {
    config.vim.extraLuaFiles = [./config.lua];
  };
}
