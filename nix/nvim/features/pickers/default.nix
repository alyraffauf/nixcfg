# Find files, text, buffers, symbols, commands, and Git objects.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = [pkgs.fd pkgs.ripgrep];
      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          dashboard.enabled = false;
          picker.enabled = true;
          notifier.enabled = false;
        };
      };
      extraLuaFiles = [./config.lua];
    };
  };
}
