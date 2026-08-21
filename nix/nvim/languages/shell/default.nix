# Provide Bash and Fish language services plus shell formatting and linting.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = with pkgs; [bash-language-server fish fish-lsp shellcheck shfmt];
      formatter.conform-nvim.setupOpts.formatters_by_ft = {
        bash = ["shfmt"];
        fish = ["fish_indent"];
        sh = ["shfmt"];
      };
      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [bash fish];
      extraLuaFiles = [./config.lua];
    };
  };
}
