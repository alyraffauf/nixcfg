_: {
  flake.darwinModules.default = {
    homebrew = {
      enable = true;
      greedyCasks = true;
    };
  };
}
