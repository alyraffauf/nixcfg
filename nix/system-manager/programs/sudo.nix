_: {
  flake.systemModules.default = {
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
