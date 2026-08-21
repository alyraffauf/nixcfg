# Show mode, Git state, file state, diagnostics, and position in a powerline.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      startPlugins = [pkgs.vimPlugins.lualine-nvim];
      extraLuaFiles = [./config.lua];
    };
  };
}
