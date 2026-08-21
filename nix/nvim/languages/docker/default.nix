# Provide Dockerfile language services, formatting, root detection, and parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = [pkgs.dockerfile-language-server pkgs.dockerfmt];
      formatter.conform-nvim.setupOpts.formatters_by_ft.dockerfile = ["dockerfmt"];
      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.dockerfile];
      extraLuaFiles = [./config.lua];
    };
  };
}
