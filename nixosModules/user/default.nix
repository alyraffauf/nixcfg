{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./aly ./dustin];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
