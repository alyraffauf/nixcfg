_: {
  flake.nixosModules.rustboro = {
    hoenn.features.homebrew = {
      enable = true;
      user = "aly";
    };
  };
}
