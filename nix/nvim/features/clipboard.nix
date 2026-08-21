# Send clipboard operations through the terminal's OSC 52 channel.
_: {
  flake.neovimModules.default = {
    config.vim.globals.clipboard = "osc52";
  };
}
