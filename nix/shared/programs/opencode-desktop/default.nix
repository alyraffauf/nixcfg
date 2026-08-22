_: {
  flake = {
    nixosModules.aly = {pkgs, ...}: {
      users.users.aly.packages = [pkgs.opencode-desktop];
    };

    darwinModules.aly = {
      homebrew.casks = ["opencode-desktop"];
    };

    systemModules.default = {pkgs, ...}: {
      environment.systemPackages = [pkgs.opencode-desktop];
    };
  };
}
