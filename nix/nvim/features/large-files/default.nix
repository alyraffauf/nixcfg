# Disable expensive editor work for files over the safety thresholds.
_: {
  flake.neovimModules.default = {
    config.vim.extraLuaFiles = [./config.lua];
  };
}
