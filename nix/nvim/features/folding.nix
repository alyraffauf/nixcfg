# Use syntax-aware folds while opening files fully expanded.
_: {
  flake.neovimModules.default = {lib, ...}: {
    config.vim = {
      options = {
        foldcolumn = "1";
        foldenable = true;
        foldlevel = 99;
        foldlevelstart = 99;
      };
      ui.nvim-ufo = {
        enable = true;
        setupOpts.provider_selector = lib.generators.mkLuaInline ''
          function()
            return { "treesitter", "indent" }
          end
        '';
      };
    };
  };
}
