# Apply the Catppuccin Frappe color scheme.
_: {
  flake.neovimModules.default = {
    config.vim.theme = {
      enable = true;
      name = "catppuccin";
      style = "frappe";
      transparent = false;
    };
  };
}
