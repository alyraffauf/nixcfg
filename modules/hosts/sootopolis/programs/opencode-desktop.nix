_: {
  flake.systemModules.sootopolis = {pkgs, ...}: {
    environment.systemPackages = [pkgs.opencode-desktop];
  };
}
