{
  inputs,
  self,
  ...
}: {
  config.flake.nixosConfigurations.pacifidlog = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      inputs.determinate.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.sops-nix.nixosModules.sops
      self.nixosModules.autoUpgrade
      self.nixosModules.default
      self.nixosModules.pacifidlog
      self.nixosModules.aly
      self.nixosModules.cosmic
      self.nixosModules.homebrew
      self.nixosModules.tailscale
      self.nixosModules.wireguardHoenn
    ];

    specialArgs = {inherit self;};
  };
}
