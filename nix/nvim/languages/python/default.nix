# Provide Ruff, ty, debugpy, Python language services, formatting, and parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: let
    debugpy-python = pkgs.python3.withPackages (python: [python.debugpy]);
  in {
    config.vim = {
      globals.hoenn_paths.debugpy_python = "${debugpy-python}/bin/python";
      extraPackages = [pkgs.ruff pkgs.ty debugpy-python];
      formatter.conform-nvim.setupOpts.formatters_by_ft.python = [
        "ruff_fix"
        "ruff_format"
        "ruff_organize_imports"
      ];
      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.python];
      startPlugins = [pkgs.vimPlugins.nvim-dap-python];
      extraLuaFiles = [./config.lua];
    };
  };
}
