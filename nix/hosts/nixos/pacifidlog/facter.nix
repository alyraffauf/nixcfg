_: {
  flake.nixosModules.pacifidlog = {self, ...}: {
    hardware.facter.reportPath = self + "/nix/hosts/nixos/pacifidlog/facter.json";
  };
}
