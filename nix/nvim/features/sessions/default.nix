# Save and restore one workspace per project root.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      startPlugins = [pkgs.vimPlugins.resession-nvim];
      extraLuaFiles = [./config.lua];
    };
  };
}
