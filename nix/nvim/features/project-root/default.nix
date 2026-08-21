# Follow the nearest Git or language project root as files change.
_: {
  flake.neovimModules.default = {
    config.vim.extraLuaFiles = [./config.lua];
  };
}
