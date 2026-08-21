# Provide Go language services, imports, formatting, static analysis, debugging, and parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = with pkgs; [delve gofumpt gopls gotools];
      formatter.conform-nvim.setupOpts.formatters_by_ft.go = ["goimports" "gofumpt"];
      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.go];
      extraLuaFiles = [./config.lua];
    };
  };
}
