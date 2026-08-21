# Display sorted, concise diagnostics with useful floating details.
_: {
  flake.neovimModules.default = {
    config.vim.diagnostics = {
      enable = true;
      config = {
        severity_sort = true;
        update_in_insert = false;
        virtual_lines = false;
        virtual_text = {
          prefix = "●";
          spacing = 2;
        };
        float = {
          border = "rounded";
          header = "";
          source = "if_many";
        };
      };
    };
  };
}
