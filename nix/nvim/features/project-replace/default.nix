# Preview and apply replacements across a project.
_: {
  flake.neovimModules.default = {
    config.vim = {
      utility.grug-far-nvim.enable = true;
      extraLuaFiles = [./config.lua];
    };
  };
}
