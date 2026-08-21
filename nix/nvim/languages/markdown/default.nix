# Provide Markdown language services, formatting, linting, and syntax parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = [pkgs.markdownlint-cli2 pkgs.marksman pkgs.prettier];
      formatter.conform-nvim.setupOpts.formatters_by_ft.markdown = ["prettier"];
      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [markdown markdown_inline];
      extraLuaFiles = [./config.lua];
    };
  };
}
