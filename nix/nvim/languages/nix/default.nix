# Provide Nix language services, formatting, linting, dead-code checks, and parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = with pkgs; [alejandra deadnix nixd statix];
      formatter.conform-nvim.setupOpts.formatters_by_ft.nix = ["alejandra"];
      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.nix];
      extraLuaFiles = [./config.lua];
    };
  };
}
