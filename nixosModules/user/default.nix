{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [./aly ./dustin];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [inputs.hyprland.homeManagerModules.default];
  };
}
