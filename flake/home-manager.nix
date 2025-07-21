_: {
  flake = {
    homeConfigurations = {
      aly = ../homes/aly;
      dustin = ../homes/dustin;
    };

    homeModules = {
      default = ../modules/home;
      snippets = ../modules/snippets;
    };
  };
}
