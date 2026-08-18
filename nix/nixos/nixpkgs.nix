{sharedPackageSets, ...}: {
  flake.nixosModules.default = {self, ...}: {
    nixpkgs.pkgs = sharedPackageSets.x86_64-linux;
    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
