_: {
  flake.nixosModules.default = {
    services.tuned = {
      enable = true;
      ppdSupport = true;
      settings.dynamic_tuning = true;
    };
  };
}
