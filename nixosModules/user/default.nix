{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./aly ./dustin];

  alyraffauf.user.aly.enable = lib.mkDefault true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
