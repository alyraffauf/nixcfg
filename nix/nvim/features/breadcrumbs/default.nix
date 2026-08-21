# Show the current file and LSP symbol path in each window bar.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      startPlugins = [pkgs.vimPlugins.nvim-navic];
      extraLuaFiles = [./config.lua];
    };
  };
}
