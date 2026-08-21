# Show open buffers, modified state, and diagnostics in the tab line.
_: {
  flake.neovimModules.default = {
    config.vim = {
      tabline.nvimBufferline = {
        enable = true;
        mappings = {
          cycleNext = "]b";
          cyclePrevious = "[b";
        };
        setupOpts.options = {
          always_show_bufferline = true;
          diagnostics = "nvim_lsp";
          numbers = "none";
          separator_style = "thin";
        };
      };
      extraLuaFiles = [./config.lua];
    };
  };
}
