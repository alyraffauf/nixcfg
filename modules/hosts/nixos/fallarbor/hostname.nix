_: {
  flake.nixosModules.fallarbor = {
    networking.hostName = "fallarbor";
    system.stateVersion = "26.05";
  };
}
