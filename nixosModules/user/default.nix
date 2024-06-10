{
  pkgs,
  lib,
  config,
  inputs,
  unstable,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./aly
    ./dustin
  ];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs unstable;};
    sharedModules = [{imports = [../../homeManagerModules];}];
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  users.mutableUsers = false;
}
