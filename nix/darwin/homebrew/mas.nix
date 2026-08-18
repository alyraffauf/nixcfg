_: {
  flake.darwinModules.default = {
    homebrew = {
      enable = true;

      brews = [
        "mas"
      ];
    };
  };
}
