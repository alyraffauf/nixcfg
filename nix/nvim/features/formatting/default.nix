# Format on save through external tools, with global and buffer toggles.
_: {
  flake.neovimModules.default = {lib, ...}: {
    config.vim = {
      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          default_format_opts = {
            lsp_format = "fallback";
            timeout_ms = 1000;
          };
          format_on_save = lib.generators.mkLuaInline ''
            function(buffer_number)
              if vim.g.hoenn_format_on_save == false or vim.b[buffer_number].hoenn_format_on_save == false or vim.b[buffer_number].hoenn_large_file then
                return
              end
              return { lsp_format = "fallback", timeout_ms = 1000 }
            end
          '';
        };
      };
      extraLuaFiles = [./config.lua];
    };
  };
}
