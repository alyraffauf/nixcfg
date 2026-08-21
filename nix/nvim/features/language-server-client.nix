# Provide shared LSP behavior without choosing language servers.
_: {
  flake.neovimModules.default = {
    config.vim.lsp = {
      enable = true;
      formatOnSave = false;
      inlayHints.enable = true;
      lightbulb.enable = true;
    };
  };
}
