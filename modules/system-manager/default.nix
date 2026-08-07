{lib, ...}: {
  options.flake.systemModules.default = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };
}
