{
  inputs,
  self,
  ...
}: {
  config.flake.nixosConfigurations.rustboro = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      inputs.determinate.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      self.nixosModules.autoUpgrade
      self.nixosModules.default
      self.nixosModules.rustboro
      self.nixosModules.aly
      self.nixosModules.cosmic
      self.nixosModules.homebrew
      self.nixosModules.tailscale
      self.nixosModules.wireguardHoenn
    ];

    specialArgs = {inherit self;};
  };
}
