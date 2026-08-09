_: {
  flake.nixosModules.fallarbor = {self, ...}: {
    hardware.facter.reportPath = self + "/modules/hosts/nixos/fallarbor/facter.json";
  };
}
