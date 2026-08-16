{sharedPackageSets, ...}: {
  flake.darwinModules.default = {
    nixpkgs.pkgs = sharedPackageSets.aarch64-darwin;
  };
}
