_: {
  flake = {
    nixosModules.aly = {pkgs, ...}: {
      users.users.aly.packages = [pkgs.google-chrome];
    };

    darwinModules.aly = {
      homebrew.casks = ["google-chrome"];
    };
  };
}
