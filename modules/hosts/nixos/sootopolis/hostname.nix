_: {
  flake.nixosModules.sootopolis = {
    networking.hostName = "sootopolis";
    system.stateVersion = "26.05";
  };
}
