_: {
  flake = {
    darwinModules.default = {
      homebrew.casks = ["firefox"];
    };

    nixosModules.default = {
      programs.firefox.enable = true;
    };
  };
}
