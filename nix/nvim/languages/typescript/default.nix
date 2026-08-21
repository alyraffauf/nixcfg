# Provide JavaScript and TypeScript language services, project-aware linting, formatting, and debugging.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      globals.hoenn_paths.js_debug = "${pkgs.vscode-js-debug}/bin/js-debug";
      extraPackages = with pkgs; [eslint oxlint prettier vscode-js-debug vtsls];
      formatter.conform-nvim.setupOpts.formatters_by_ft = {
        javascript = ["prettier"];
        javascriptreact = ["prettier"];
        typescript = ["prettier"];
        typescriptreact = ["prettier"];
      };
      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
        javascript
        tsx
        typescript
      ];
      extraLuaFiles = [./config.lua];
    };
  };
}
