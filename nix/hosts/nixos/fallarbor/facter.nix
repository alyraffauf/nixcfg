_: {
  flake.nixosModules.fallarbor = {self, ...}: {
    hardware.facter.reportPath = self + "/nix/hosts/nixos/fallarbor/facter.json";
  };
}
