{inputs, ...}: {
  flake.homeModules.aly = {pkgs, ...}: {
    home.packages = [
      inputs.eevee.packages.${pkgs.stdenv.hostPlatform.system}.sylveon
    ];
  };
}
