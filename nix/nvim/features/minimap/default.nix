# Provide a closed-by-default, explicitly toggled minimap.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      startPlugins = [pkgs.vimPlugins.mini-nvim];
      extraLuaFiles = [./config.lua];
    };
  };
}
