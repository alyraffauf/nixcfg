_: {
  flake.nixosModules.default = {
    services.tuned = {
      enable = true;
      settings.dynamic_tuning = true;
    };
  };
}
