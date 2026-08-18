_: {
  flake.systemModules.default = {pkgs, ...}: {
    environment.systemPackages = [pkgs.opencode-desktop];
  };
}
