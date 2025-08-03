{
  self,
  inputs,
  ...
}: {
  flake = {
    darwinModules.default = ../darwin;

    darwinConfigurations.fortree = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        ../../hosts/fortree
        self.darwinModules.default
        inputs.agenix.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
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

      specialArgs = {inherit self;};
    };
  };
}
