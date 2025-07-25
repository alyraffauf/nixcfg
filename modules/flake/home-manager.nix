_: {
  flake = {
    homeConfigurations = {
      aly = ../../homes/aly;
      dustin = ../../homes/dustin;
    };

    homeModules = {
      default = ../home;
      snippets = ../snippets;
    };
  };
}
