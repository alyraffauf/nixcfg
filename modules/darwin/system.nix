_: {
  flake.darwinModules.default = {self, ...}: {
    nixpkgs.hostPlatform = "aarch64-darwin";

    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      primaryUser = "aly";
      stateVersion = 6;
    };
  };
}
