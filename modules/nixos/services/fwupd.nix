_: {
  flake.nixosModules.default = {
    services.fwupd.enable = true;
  };
}
