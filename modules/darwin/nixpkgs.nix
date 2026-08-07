_: {
  flake.darwinModules.default = {self, ...}: {
    nixpkgs = {
      overlays = [self.overlays.default];
      config.allowUnfree = true;
    };
  };
}
