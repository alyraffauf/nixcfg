_: {
  flake.nixosModules.sootopolis = {self, ...}: {
    home-manager = {
      extraSpecialArgs = {inherit self;};
      useGlobalPkgs = true;
      useUserPackages = true;
      users.aly = {
        home = {
          homeDirectory = "/home/aly";
          stateVersion = "26.05";
          username = "aly";
        };

        imports = [self.homeModules.aly];
      };
    };
  };
}
