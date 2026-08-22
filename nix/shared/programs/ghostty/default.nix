_: {
  flake = {
    nixosModules.aly = {pkgs, ...}: {
      users.users.aly.packages = [pkgs.ghostty];
    };

    darwinModules.default = {
      homebrew.casks = ["ghostty"];
    };

    systemModules.default = {pkgs, ...}: {
      environment.systemPackages = [pkgs.ghostty];
    };
  };
}
