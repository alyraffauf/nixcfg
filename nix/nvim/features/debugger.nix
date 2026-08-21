# Provide the shared DAP client and an on-demand debugger interface.
_: {
  flake.neovimModules.default = {
    config.vim.debugger.nvim-dap = {
      enable = true;
      ui = {
        enable = true;
        autoStart = false;
      };
    };
  };
}
