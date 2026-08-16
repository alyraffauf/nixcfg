_: {
  flake.nixosModules.mauville = {
    networking.hostName = "mauville";
    system.stateVersion = "26.05";
  };
}
