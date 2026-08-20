{
  inputs,
  self,
  ...
}: {
  config.flake.nixosConfigurations.mauville = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      inputs.determinate.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.sops-nix.nixosModules.sops
      self.nixosModules.autoUpgrade
      self.nixosModules.default
      self.nixosModules.mauville
      self.nixosModules.aly
      self.nixosModules.gnome
      self.nixosModules.homebrew
      self.nixosModules.tailscale
      self.nixosModules.thermald
      self.nixosModules.wireguardHoenn
    ];

    specialArgs = {inherit self;};
  };
}
