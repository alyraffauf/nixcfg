# Provide JSON and YAML language services, schemas, formatting, and parsing.
{inputs, ...}: {
  flake.neovimModules.default = {pkgs, ...}: let
    schemastore-nvim = pkgs.vimUtils.buildVimPlugin {
      pname = "SchemaStore.nvim";
      version = "unstable";
      src = inputs.schemastore-nvim;
    };
  in {
    config.vim = {
      extraPackages = [pkgs.prettier pkgs.yaml-language-server pkgs.vscode-langservers-extracted];
      formatter.conform-nvim.setupOpts.formatters_by_ft = {
        json = ["prettier"];
        jsonc = ["prettier"];
        yaml = ["prettier"];
      };
      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [json yaml];
      startPlugins = [schemastore-nvim];
      extraLuaFiles = [./config.lua];
    };
  };
}
