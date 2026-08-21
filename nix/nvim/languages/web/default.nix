# Provide HTML, CSS, Emmet, and project-gated Tailwind language services.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = with pkgs; [
        emmet-language-server
        prettier
        tailwindcss-language-server
        vscode-langservers-extracted
      ];
      formatter.conform-nvim.setupOpts.formatters_by_ft = {
        css = ["prettier"];
        html = ["prettier"];
        scss = ["prettier"];
      };
      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [css html];
      extraLuaFiles = [./config.lua];
    };
  };
}
