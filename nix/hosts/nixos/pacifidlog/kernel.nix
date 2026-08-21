_: {
  flake.nixosModules.pacifidlog = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
