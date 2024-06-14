{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./aly
    ./dustin
    ./morgan
  ];

  home-manager = {
    backupFileExtension = "backup";
    sharedModules = [self.homeManagerModules.default];
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  users.mutableUsers = false;
}
