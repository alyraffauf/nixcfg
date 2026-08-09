_: {
  flake.nixosModules.rustboro = {self, ...}: {
    hardware.facter.reportPath = self + "/modules/hosts/nixos/rustboro/facter.json";
  };
}
