{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users = {
    aly = {
      imports = [../../homeManagerModules ../../aly.nix];
    };
    dustin = {
      imports = [../../homeManagerModules ../../dustin.nix];
    };
  };
}
