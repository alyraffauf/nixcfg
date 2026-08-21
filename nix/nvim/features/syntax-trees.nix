# Parse buffers with Treesitter for highlighting and indentation.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim.treesitter = {
      enable = true;
      indent.enable = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [regex toml];
    };
  };
}
