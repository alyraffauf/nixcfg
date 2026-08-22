{inputs, ...}: let
  neovimPackage = pkgs: inputs.eevee.packages.${pkgs.stdenv.hostPlatform.system}.sylveon;
in {
  flake = {
    homeModules.aly = {pkgs, ...}: {
      home.packages = [(neovimPackage pkgs)];
    };

    nixosModules.aly = {pkgs, ...}: {
      users.users.aly.packages = [(neovimPackage pkgs)];
    };

    darwinModules.default = {pkgs, ...}: {
      environment.systemPackages = [(neovimPackage pkgs)];
    };
  };
}
