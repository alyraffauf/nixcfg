# Complete from LSP, paths, snippets, and buffers without intrusive previews.
_: {
  flake.neovimModules.default = {lib, ...}: {
    config.vim = {
      options.pumheight = 12;
      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        setupOpts = {
          enabled = lib.generators.mkLuaInline ''
            function()
              return not vim.b.hoenn_large_file
            end
          '';
          sources.default = ["lsp" "path" "snippets" "buffer"];
          completion = {
            documentation.auto_show = false;
            ghost_text.enabled = false;
            menu = {
              auto_show = true;
              border = "rounded";
              draw.treesitter = ["lsp"];
            };
          };
          signature.enabled = false;
          keymap.preset = "default";
        };
      };
      snippets.luasnip.enable = true;
    };
  };
}
