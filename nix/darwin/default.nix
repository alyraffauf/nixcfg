{lib, ...}: {
  options.flake.darwinModules.default = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };
}
