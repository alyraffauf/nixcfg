# Render visible Markdown images only in supported image terminals.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = [pkgs.imagemagick];
      startPlugins = [pkgs.vimPlugins.image-nvim];
      extraLuaFiles = [./config.lua];
    };
  };
}
