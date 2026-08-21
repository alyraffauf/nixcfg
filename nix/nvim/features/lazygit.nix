# Run the Nix-provided lazygit binary in a ToggleTerm window.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = [pkgs.lazygit];
      terminal.toggleterm.lazygit.enable = true;
    };
  };
}
