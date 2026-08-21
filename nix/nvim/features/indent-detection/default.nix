# Honor EditorConfig and infer indentation when it is absent.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      startPlugins = [pkgs.vimPlugins.guess-indent-nvim];
      extraLuaFiles = [./config.lua];
    };
  };
}
