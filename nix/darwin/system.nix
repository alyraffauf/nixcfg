{sharedPackageSets, ...}: {
  flake.darwinModules.default = {
    nixpkgs = {
      hostPlatform = "aarch64-darwin";
      pkgs = sharedPackageSets.aarch64-darwin;
    };

    system = {
      primaryUser = "aly";
    };
  };
}
