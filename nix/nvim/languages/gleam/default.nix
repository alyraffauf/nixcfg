# Provide the Gleam toolchain, language server, formatter, debugger hooks, and parser.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = [pkgs.gleam];
      formatter.conform-nvim.setupOpts.formatters_by_ft.gleam = ["gleam"];
      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.gleam];
      extraLuaFiles = [./config.lua];
    };
  };
}
