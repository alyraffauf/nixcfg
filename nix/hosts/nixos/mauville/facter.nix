_: {
  flake.nixosModules.mauville = {self, ...}: {
    hardware.facter.reportPath = self + "/nix/hosts/nixos/mauville/facter.json";
  };
}
