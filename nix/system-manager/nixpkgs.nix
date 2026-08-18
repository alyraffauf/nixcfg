{sharedPackageSets, ...}: {
  flake.systemModules.default = {lib, ...}: {
    # Replace system-manager's package-set import with the shared instance.
    _module.args.pkgs = lib.mkForce sharedPackageSets.x86_64-linux;

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
