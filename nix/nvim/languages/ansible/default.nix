# Provide Ansible file detection, language services, linting, and syntax parsing.
_: {
  flake.neovimModules.default = {pkgs, ...}: {
    config.vim = {
      extraPackages = [pkgs.ansible-language-server pkgs.ansible-lint];
      extraLuaFiles = [./config.lua];
    };
  };
}
