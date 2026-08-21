# Provide Lua language services, formatting, linting, and syntax parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = with pkgs; [lua-language-server selene stylua];
      formatter.conform-nvim.setupOpts.formatters_by_ft.lua = ["stylua"];
      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.lua];
      extraLuaFiles = [./config.lua];
    };
  };
}
