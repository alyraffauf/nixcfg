self: {
  imports = [
    ./common.nix
    ./secrets.nix
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
  ];

  programs.helix.defaultEditor = true;
}
