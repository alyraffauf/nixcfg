_: {
  flake.nixosModules.default = {
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
