{
  self,
  inputs,
  ...
}: {
  flake.darwinModules.default = ../modules/darwin;

  flake.darwinConfigurations.fortree = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {inherit self;};
    modules = [
      ../hosts/fortree
      self.darwinModules.default
      inputs.agenix.darwinModules.default
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.stylix.darwinModules.stylix
      self.nixosModules.snippets

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit self;};
          backupFileExtension = "backup";
        };

        nixpkgs = {
          overlays = [
            self.inputs.nur.overlays.default
            self.overlays.default
          ];

          config.allowUnfree = true;
        };
      }
    ];
  };
}
