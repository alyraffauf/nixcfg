{self, ...}: {
  flake = {
    homeConfigurations = {
      "aly@pacifidlog" = self.inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit self;};

        modules = [
          ../../homes/aly/pacifidlog.nix
        ];

        pkgs = import self.inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;

          overlays = [
            self.inputs.nixgl.overlay
            self.inputs.nur.overlays.default
            self.overlays.default
          ];
        };
      };
    };

    homeModules = {
      default = ../home;
      aly = ../../homes/aly;
      dustin = ../../homes/dustin;
    };
  };
}
