# Open ordinary shell terminals in ToggleTerm.
_: {
  flake.neovimModules.default = {
    config.vim = {
      terminal.toggleterm.enable = true;
      extraLuaFiles = [./config.lua];
    };
  };
}
