_: {
  flake.homeManagerModules = {
    aly = ../homes/aly;
    dustin = ../homes/dustin;
    default = ../modules/home;
    snippets = ../modules/snippets;
  };
}
