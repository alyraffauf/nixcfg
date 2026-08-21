# Briefly highlight text after it is copied.
_: {
  flake.neovimModules.default = {
    config.vim.extraLuaFiles = [./config.lua];
  };
}
