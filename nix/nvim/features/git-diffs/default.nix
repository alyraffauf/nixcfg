# Inspect repository changes in Diffview with matching syntax parsers.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      utility.diffview-nvim.enable = true;
      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
        diff
        git_config
        gitignore
      ];
      extraLuaFiles = [./config.lua];
    };
  };
}
