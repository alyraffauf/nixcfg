_: {
  flake.nixosModules.default = {
    networking.networkmanager.enable = true;
  };
}
