_: {
  flake.nixosModules.default = {
    services.fstrim.enable = true;
  };
}
