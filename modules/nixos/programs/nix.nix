_: {
  flake.nixosModules.default = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
