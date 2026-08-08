_: {
  flake.nixosModules.default = {pkgs, ...}: {
    environment.systemPackages = [pkgs.opencode-desktop];
  };
}
