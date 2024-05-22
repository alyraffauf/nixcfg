{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.sharedModules = [
    {
      imports = [../../homeManagerModules];
      alyraffauf.services.easyeffects = {
        enable = true;
        preset = "framework13";
      };
    }
  ];
  home-manager.users.aly = {
    imports = [../../homeManagerModules ../../aly.nix];
  };
}
