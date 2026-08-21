# Present commands, searches, and long messages through Noice.
_: {
  flake.neovimModules.default = {
    config.vim.ui.noice = {
      enable = true;
      setupOpts = {
        notify.enabled = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };
    };
  };
}
