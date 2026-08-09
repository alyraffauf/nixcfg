_: {
  flake.nixosModules.sootopolis = {self, ...}: {
    hardware.facter.reportPath = self + "/modules/hosts/nixos/sootopolis/facter.json";
  };
}
