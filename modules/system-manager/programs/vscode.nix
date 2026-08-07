_: {
  flake.systemModules.default = {pkgs, ...}: {
    environment.systemPackages = [pkgs.vscode];
  };
}
