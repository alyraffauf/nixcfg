_: {
  flake.nixosModules.rustboro = {self, ...}: {
    hardware.facter.reportPath = self + "/modules/hosts/rustboro/facter.json";
  };
}
