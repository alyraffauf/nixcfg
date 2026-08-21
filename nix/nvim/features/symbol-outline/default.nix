# Show the current document's symbols in an Aerial side panel.
_: {
  flake.neovimModules.default = {
    config.vim = {
      utility.outline.aerial-nvim.enable = true;
      extraLuaFiles = [./config.lua];
    };
  };
}
