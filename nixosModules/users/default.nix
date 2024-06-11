{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./aly
    ./dustin
  ];

  home-manager = {
    backupFileExtension = "backup";
    sharedModules = [self.homeManagerModules.default];
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  users.mutableUsers = false;
}
