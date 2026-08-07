_: {
  flake.systemModules.sootopolis = {pkgs, ...}: {
    environment.systemPackages = [pkgs.ghostty];
  };
}
