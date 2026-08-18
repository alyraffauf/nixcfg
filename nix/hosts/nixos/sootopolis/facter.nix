_: {
  flake.nixosModules.sootopolis = {self, ...}: {
    hardware.facter.reportPath = self + "/nix/hosts/nixos/sootopolis/facter.json";
  };
}
