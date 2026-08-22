_: let
  module = {pkgs, ...}: {
    environment.systemPackages = [pkgs.htop];
  };
in {
  flake = {
    darwinModules.default = module;

    homeModules.aly = {pkgs, ...}: {
      home.packages = [pkgs.htop];
    };

    nixosModules.default = module;
  };
}
