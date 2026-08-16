_: {
  flake.nixosModules.aly = {pkgs, ...}: {
    users.users.aly.packages = [pkgs.ghostty];
  };
} 
