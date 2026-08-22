{sharedPackageSets, ...}: {
  flake.nixosModules.default = {
    nixpkgs.pkgs = sharedPackageSets.x86_64-linux;
  };
}
