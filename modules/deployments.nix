{self, ...}: {
  blzrd.nodes.mauville = {
    output = self.nixosConfigurations.mauville.config.system.build.toplevel;
    type = "nixos";
    user = "root";
  };
}
