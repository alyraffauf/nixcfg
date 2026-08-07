{
  lib,
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations.fortree = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.sops-nix.darwinModules.sops
      (inputs.import-tree.initFilter (path: lib.hasSuffix ".nix" path) ./_modules)

      {
        nixpkgs = {
          overlays = [self.overlays.default];
          config.allowUnfree = true;
        };
      }
    ];

    specialArgs = {inherit self;};
  };
}
