_: {
  flake.nixosModules.pacifidlog = {self, ...}: {
    hardware.facter.reportPath = self + "/modules/hosts/nixos/pacifidlog/facter.json";
  };
}
