_: {
  flake.nixosModules.default = {
    nixpkgs.config.allowUnfree = true;
  };
}
