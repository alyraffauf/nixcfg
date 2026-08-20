{
  lib,
  self,
  inputs,
  ...
}: {
  options.flake.darwinModules.fortree = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };

  config.flake.darwinConfigurations.fortree = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.home-manager.darwinModules.home-manager
      inputs.sops-nix.darwinModules.sops
      self.darwinModules.default
      self.darwinModules.fortree
    ];

    specialArgs = {inherit self;};
  };
}
