_: {
  flake.nixosModules.rustboro = {
    networking.hostName = "rustboro";
    system.stateVersion = "26.05";
  };
}
