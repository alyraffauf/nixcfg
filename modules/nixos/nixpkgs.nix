_: {
  flake.nixosModules.default = {self, ...}: {
    nixpkgs.config.allowUnfree = true;
    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
