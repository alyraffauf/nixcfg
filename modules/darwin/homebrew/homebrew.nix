_: {
  flake.darwinModules.default = {
    homebrew = {
      enable = true;
      global.autoUpdate = true;

      onActivation = {
        # cleanup = "zap";
        upgrade = true;
      };
    };
  };
}
