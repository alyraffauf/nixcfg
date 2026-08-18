_: {
  flake.nixosModules.rustboro = {self, ...}: {
    hardware.facter.reportPath = self + "/nix/hosts/nixos/rustboro/facter.json";
  };
}
