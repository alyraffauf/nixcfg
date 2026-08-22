_: let
  module = {self, ...}: {
    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
in {
  flake = {
    nixosModules.default = module;
    darwinModules.default = module;
  };
}
