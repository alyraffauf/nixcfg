_: {
  flake.nixosModules.mauville = {self, ...}: {
    hardware.facter.reportPath = self + "/modules/hosts/nixos/mauville/facter.json";
  };
}
