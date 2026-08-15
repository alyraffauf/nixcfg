{
  inputs,
  self,
  ...
}: {
  config.flake.nixosConfigurations.fallarbor = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      inputs.determinate.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.sops-nix.nixosModules.sops
      self.nixosModules.cosmic
      self.nixosModules.default
      self.nixosModules.fallarbor
    ];

    specialArgs = {inherit self;};
  };
}
