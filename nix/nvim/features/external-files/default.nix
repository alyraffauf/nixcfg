# Notice files changed outside Neovim when focus returns.
_: {
  flake.neovimModules.default = {
    config.vim.extraLuaFiles = [./config.lua];
  };
}
