# Save eligible modified file buffers after idle and focus transitions.
_: {
  flake.neovimModules.default = {
    config.vim = {
      options.updatetime = 800;
      extraLuaFiles = [./config.lua];
    };
  };
}
