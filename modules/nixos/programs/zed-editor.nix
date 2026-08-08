_: {
  flake.nixosModules.default = {pkgs, ...}: {
    environment.systemPackages = [pkgs.zed-editor];
  };
}
